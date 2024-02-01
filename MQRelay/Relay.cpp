#include "Relay.h"
#include <sw/redis++/queued_redis.h>

template<typename Func>
long long measureTime(Func f) {
	const auto start = std::chrono::high_resolution_clock::now();
	f(); // Execute the function
	const auto end = std::chrono::high_resolution_clock::now();

	return std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
}

void Relay::Update()
{
	const auto time = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
	sw::redis::Pipeline pipe = _redis->pipeline(false);
	if (time >= _characterStatsUpdateTime)
	{
		UpdateCharacterStats(pipe);
		_characterStatsUpdateTime = time + _timings.CharacterStatsUpdateFrequency;
	}
	if (time >= _characterStateUpdateTime)
	{
		UpdateCharacterState(pipe);
		_characterStateUpdateTime = time + _timings.CharacterStateUpdateFrequency;
	}
	if (time >= _spawnsUpdateTime)
	{
		UpdateSpawnData(pipe, time);
		_spawnsUpdateTime = time + _timings.SpawnsUpdateFrequency;
	}
	if (time >= _xTargetsUpdateTime)
	{
		UpdateXTargetData(pipe, time);
		_xTargetsUpdateTime = time + _timings.XTargetUpdateFrequency;
	}
	if (time >= _buffsUpdateTime)
	{
		UpdateBuffData(pipe);
		_buffsUpdateTime = time + _timings.BuffUpdateFrequency;
	}
	pipe.expire(GetCharacterKey(), _timings.CharacterExpireTime);
	pipe.exec();

}

void Relay::LoadSpellData(sw::redis::Pipeline& pipeline, const std::string& key, const EQ_Affect& buff) const
{
	pipeline.hset(key, "SpellId", ToString(buff.SpellID ? buff.SpellID : -1));

	if (buff.SpellID > 0)
	{
		pipeline.hset(key, "Duration", ToString(GetSpellBuffTimer(buff.SpellID)));
		pipeline.hset(key, "CorruptionCounters", std::to_string(GetSpellCounters(SPA_CORRUPTION, buff)));
		pipeline.hset(key, "CurseCounters", std::to_string(GetSpellCounters(SPA_CURSE, buff)));
		pipeline.hset(key, "DiseaseCounters", std::to_string(GetSpellCounters(SPA_DISEASE, buff)));
		pipeline.hset(key, "PoisonCounters", std::to_string(GetSpellCounters(SPA_POISON, buff)));
		pipeline.hset(key, "HitCount", ToString(buff.HitCount));
	}
	pipeline.expire(key, _timings.CharacterBuffExpireTime);
}

void Relay::UpdateBuffData(sw::redis::Pipeline& pipeline) const
{
	const auto* characterInfo2 = GetPcProfile();
	const std::string baseBuffKey = GetCharacterKey() + ":buffs:";
	const std::string baseSongKey = GetCharacterKey() + ":songs:";

	for (int i = 0; i < NUM_LONG_BUFFS; ++i)
	{
		auto buffKey = baseBuffKey + std::to_string(i);

		const auto& buff = characterInfo2->GetEffect(i);
		LoadSpellData(pipeline, buffKey, buff);
	}
	for (int i = 0; i < NUM_SHORT_BUFFS; ++i)
	{
		auto songKey = baseSongKey + std::to_string(i);

		const auto& buff = characterInfo2->GetTempEffect(i);
		LoadSpellData(pipeline, songKey, buff);
	}
}

void Relay::UpdateCharacterState(sw::redis::Pipeline& pipeline)
{
	const std::string key = GetCharacterKey();
	const auto targetId = pTarget ? pTarget->SpawnID : 0;
	pipeline.hset(key, "CurrentHP", std::to_string(GetCurHPS()));
	pipeline.hset(key, "CurrentMana", std::to_string(GetCurMana()));
	pipeline.hset(key, "CurrentEndurance", std::to_string(GetCurEndurance()));
	pipeline.hset(key, "CombatState", GetCombatState());
	pipeline.hset(key, "Casting", std::to_string(pLocalPlayer->CastingData.SpellID));
	pipeline.hset(key, "CastingTargetId", std::to_string(pLocalPlayer->CastingData.TargetID));
	pipeline.hset(key, "CastingETA", std::to_string(pLocalPlayer->CastingData.SpellETA));
	pipeline.hset(key, "AutoAttacking", std::to_string(pEverQuestInfo->bAutoAttack));
	pipeline.hset(key, "AutoFiring", std::to_string(pEverQuestInfo->bAutoRangeAttack != 0));
	pipeline.hset(key, "Heading", std::to_string(pLocalPlayer->Heading * 0.703125f));
	pipeline.hset(key, "TargetId", std::to_string(targetId));
	pipeline.hset(key, "PctAggro", ToString(pAggroInfo->aggroData[AD_Player].AggroPct));

	pipeline.hset(key, "X", std::to_string(pLocalPlayer->X));
	pipeline.hset(key, "Y", std::to_string(pLocalPlayer->Y));
	pipeline.hset(key, "Z", std::to_string(pLocalPlayer->Z));

	if (targetId > 0)
	{
		const char* serverShortName = GetServerShortName();
		const char* zoneShortname = pZoneInfo->ShortName;
		std::ostringstream oss;
		oss << serverShortName << ":" << zoneShortname << ":spawns:" << targetId;
		const std::string spawnKey = oss.str();

		//TODO: These may need a script to prevent constant updating from multiple clients
		pipeline.hset(spawnKey, "TargetOfTarget", ToString(pLocalPlayer->TargetOfTarget));
		pipeline.hset(spawnKey, "SecondaryAggroId", ToString(pAggroInfo->AggroSecondaryID));
		pipeline.hset(spawnKey, "SecondaryAggroPct", ToString(pAggroInfo->aggroData[AD_Secondary].AggroPct));
	}
}

void Relay::UpdateSpawnData(sw::redis::Pipeline& pipeline, long long time) const
{
	//we did everything we could think of to speed up this loop. Each loop of gathering the data takes 0.01ms and the sending to the pipeline takes about the same
	//we don't use the std::to_string here because in total it saved us about 4ms for a full loop of 600
	auto* spawn = pSpawnManager->FirstSpawn;
	const char* serverShortName = GetServerShortName();
	const char* zoneShortname = pZoneInfo->ShortName;
	std::ostringstream oss;
	oss << serverShortName << ":" << zoneShortname << ":spawns:";
	std::string baseKey = oss.str();

	auto expirationTime = ToString(_timings.SpawnExpireTime);
	auto timeString = std::to_string(time);

	//These are just for profiling
	//TODO: start profiling code
	sw::redis::StringView x;
	char yBuffer[64] = { 0 };
	sw::redis::StringView y;
	long long xTime = 0;
	long long yTime = 0;
	long long spawnCount = 0;
	//TODO: end profiling code
	while (spawn)
	{
		spawnCount++;
		std::string key = baseKey + ToString(spawn->SpawnID);

		unsigned ownerId = 0;

		if (spawn->Mercenary)
		{
			size_t pos = strchr(spawn->Lastname, '\'') - &spawn->Lastname[0];
			strncpy_s(DataTypeTemp, spawn->Lastname, pos);

			DataTypeTemp[pos] = 0;

			if (SPAWNINFO* pOwner = GetSpawnByName(DataTypeTemp))
			{
				ownerId = pOwner->SpawnID;
			}
		}

		//These are just for profiling
		//TODO: start of profiling code
		xTime += measureTime([&]() {
			x = sw::redis::StringView(ToString(spawn->X, 2));
			});

		yTime += measureTime([&]() {
			snprintf(yBuffer, sizeof(yBuffer), "%.*f", 2, spawn->Y);  // NOLINT(cert-err33-c)
			y = sw::redis::StringView(yBuffer);
			});

		//TODO: End of profiling code
		pipeline.evalsha(_spawnScriptSHA, { key }, { sw::redis::StringView(timeString),
			sw::redis::StringView(ToString(GetDistanceSquared(pControlledPlayer,spawn),2)),
			sw::redis::StringView(expirationTime),
			sw::redis::StringView("Class"),sw::redis::StringView(ToString(spawn->GetClass())),
			sw::redis::StringView("Type"),sw::redis::StringView(ToString(GetSpawnType(spawn))),
			sw::redis::StringView("Name"),sw::redis::StringView(spawn->Name),
			sw::redis::StringView("Heading"),sw::redis::StringView(ToString(spawn->Heading * 0.703125f,2)),
			sw::redis::StringView("Level"),sw::redis::StringView(ToString(spawn->Level)),
			sw::redis::StringView("Mark"),sw::redis::StringView(ToString(GetNPCMarkNumber(spawn))),
			sw::redis::StringView("MasterId"),sw::redis::StringView(ToString(spawn->MasterID)),
			sw::redis::StringView("OwnerId"),sw::redis::StringView(ToString(ownerId)),
			sw::redis::StringView("PetId"),sw::redis::StringView(ToString(spawn->PetID)),
			sw::redis::StringView("MaxRange"),sw::redis::StringView(ToString(GetMeleeRange(spawn,pControlledPlayer),2)),
			sw::redis::StringView("MaxRangeTo"),sw::redis::StringView(ToString(GetMeleeRange(pControlledPlayer,spawn),2)),
			sw::redis::StringView("Speed"),sw::redis::StringView(ToString(FindSpeed(spawn),2)),
			sw::redis::StringView("Stunned"),sw::redis::StringView(ToString((spawn->PlayerState & 0x20) != 0)),
			sw::redis::StringView("Targetable"),sw::redis::StringView(ToString(spawn->Targetable)),
			sw::redis::StringView("X"),x,
			sw::redis::StringView("Y"),y,
			sw::redis::StringView("Z"),sw::redis::StringView(ToString(spawn->Z,2)) });
		if (const int count = GetCachedBuffCount(spawn))
		{

			for (int i = 0; i < count; ++i)
			{
				auto buffSlot = GetCachedBuffAt(spawn, i);
				auto buffKey = key + ":buffs:" + ToString(buffSlot);
				auto cachedBuff = GetCachedBuffAtSlot(spawn, buffSlot);
				if (!cachedBuff)
				{
					continue;
				}
				pipeline.evalsha(_spawnBuffScriptSHA, { buffKey }, {
					ToString(cachedBuff->Staleness()),
					timeString,
					ToString(cachedBuff->spellId),
					cachedBuff->casterName,
					ToString(cachedBuff->Duration())
					});
			}
		}
		spawn = spawn->GetNext();
	}
	//avoiding divide by 0
	spawnCount = spawnCount ? spawnCount : 1;
	WriteChatColorf("x->ToString(spawn->X) took %lld an average of %f", CONCOLOR_LIGHTBLUE, xTime, xTime / spawnCount);
	WriteChatColorf("buffered y took %lld an average of %f", CONCOLOR_LIGHTBLUE, yTime, yTime / spawnCount);
}

void Relay::UpdateCharacterStats(sw::redis::Pipeline& pipeline)
{
	const std::string key = GetCharacterKey();
	// Queue Redis commands using the pipeline
	pipeline.hset(key, "SpawnId", std::to_string(pLocalPlayer->SpawnID));
	pipeline.hset(key, "MaxHP", std::to_string(GetMaxHPS()));
	pipeline.hset(key, "MaxMana", std::to_string(GetMaxMana()));
	pipeline.hset(key, "MaxEndurance", std::to_string(GetMaxEndurance()));
	pipeline.hset(key, "Level", std::to_string(pLocalPlayer->Level));
	pipeline.hset(key, "PctExp", std::to_string(static_cast<float>(pLocalPC->Exp) / EXP_TO_PCT_RATIO));
	pipeline.hset(key, "PctAAExp", std::to_string(static_cast<float>(pLocalPC->AAExp) / EXP_TO_PCT_RATIO));
	pipeline.hset(key, "Class", std::to_string(pLocalPlayer->GetClass()));
	pipeline.hset(key, "Zone", pZoneInfo->ShortName);
	pipeline.hset(key, "GroupLeader", GetLeaderName());
}

void Relay::UpdateXTargetData(sw::redis::Pipeline& pipeline, const long long time) const
{
	const auto key = GetCharacterKey() + ":XTargets:";
	const std::string serverShortName = GetServerShortName();
	const std::string zoneShortname = pZoneInfo->ShortName;
	const std::string baseSpawnKey = serverShortName + ":" + zoneShortname + ":spawns:";
	const auto expirationTime = ToString(_timings.SpawnExpireTime);
	const auto timeString = std::to_string(time);
	const auto xManager = GetCharInfo()->pXTargetMgr;
	if (!xManager || !xManager->XTargetSlots.Count)
	{
		return;
	}
	for (auto i = 0; i < xManager->XTargetSlots.Count; i++)
	{
		if (const auto [xTargetType, XTargetSlotStatus, spawnId, _] = xManager->XTargetSlots[i]; xTargetType && XTargetSlotStatus)
		{
			auto currentKey = key + std::to_string(spawnId);
			auto spawnKey = baseSpawnKey + std::to_string(spawnId);
			const auto spawn = GetSpawnByID(spawnId);
			pipeline.hset(currentKey, "AggroPercentage", ToString(pAggroInfo->aggroData[AD_xTarget1 + i].AggroPct));
			pipeline.hset(currentKey, "Type", pLocalPC->pXTargetMgr->ExtendedTargetRoleName(xTargetType));
			pipeline.hset(currentKey, "HeadingTo", pLocalPC->pXTargetMgr->ExtendedTargetRoleName(xTargetType));
			pipeline.hset(currentKey, "LineOfSight", std::to_string(pControlledPlayer->CanSee(*spawn)));
			pipeline.expire(currentKey, _timings.XTargetExpireTime);

			//This updates the spawn, not the XTarget
			pipeline.evalsha(_spawnHPScriptSHA, { spawnKey },
							 {
								 sw::redis::StringView(timeString),
								 sw::redis::StringView(ToString(1)),
								 sw::redis::StringView(expirationTime),
								 std::to_string(GetPctHP(GetSpawnByID(spawnId)))
							 });
		}
	}
}

void Relay::UpdateGroupData(sw::redis::Pipeline& pipeline) const
{
	//If we're grouped
	if (pLocalPC->Group != nullptr && pLocalPC->Group->IsGroupLeader(pLocalPC->me))
	{
		const std::string serverName = GetServerShortName();
		const auto groupKey = serverName + ":" + GetLeaderName();
		CGroupMember* groupPuller = pLocalPC->Group->GetGroupMemberByRole(GroupRolePuller);
		CGroupMember* groupAssist = pLocalPC->Group->GetGroupMemberByRole(GroupRoleAssist);
		CGroupMember* groupTank = pLocalPC->Group->GetGroupMemberByRole(GroupRoleTank);
		CGroupMember* groupLooter = pLocalPC->Group->GetGroupMemberByRole(GroupRoleMasterLooter);
		CGroupMember* groupMarker = pLocalPC->Group->GetGroupMemberByRole(GroupRoleMarkNPC);
		pipeline.hset(groupKey, "Puller ", ToString(groupPuller ? groupPuller->pSpawn->SpawnID : 0));
		pipeline.hset(groupKey, "Assist", ToString(groupAssist ? groupAssist->pSpawn->SpawnID : 0));
		pipeline.hset(groupKey, "Tank", ToString(groupTank ? groupTank->pSpawn->SpawnID : 0));
		pipeline.hset(groupKey, "Looter", ToString(groupLooter ? groupLooter->pSpawn->SpawnID : 0));
		pipeline.hset(groupKey, "Marker", ToString(groupMarker? groupMarker->pSpawn->SpawnID : 0));
		pipeline.expire(groupKey, _timings.GroupExpireTime);
	}
}

std::string Relay::GetCombatState()
{
	switch (pPlayerWnd->CombatState)
	{
	case eCombatState_Combat:
		if (pPlayerWnd->GetChildItem("PW_CombatStateAnim"))
		{
			return "COMBAT";
		}
		return "NULL";

	case eCombatState_Debuff:
		return "DEBUFFED";

	case eCombatState_Timer:
		return "COOLDOWN";

	case eCombatState_Standing:
		return "ACTIVE";

	case eCombatState_Regen:
		return "RESTING";

	default:
		char buffer[MAX_STRING] = { 0 };
		sprintf_s(buffer, "UNKNOWN(%d)", pPlayerWnd->CombatState);// NOLINT(cert-err33-c)
		return buffer;
	}
}

std::string Relay::ToString(int value) {
	char buffer[11]; // Enough to hold all digits of an int
	snprintf(buffer, sizeof(buffer), "%d", value); // NOLINT(cert-err33-c)
	return std::string(buffer);
}

std::string Relay::ToString(unsigned int value) {
	char buffer[11]; // Maximum length of unsigned int representation + 1 for null-terminator
	snprintf(buffer, sizeof(buffer), "%u", value); // NOLINT(cert-err33-c)
	return std::string(buffer);
}

std::string Relay::ToString(uint8_t value) {
	char buffer[4]; // A buffer of 4 is enough for any value 0-255 and the null terminator
	snprintf(buffer, sizeof(buffer), "%u", value); // NOLINT(cert-err33-c)
	return std::string(buffer);
}

std::string Relay::ToString(float value, int precision = 2) {
	char buffer[64]; // Should be large enough for most floats with specified precision
	snprintf(buffer, sizeof(buffer), "%.*f", precision, value); // NOLINT(cert-err33-c)
	return std::string(buffer);
}

std::string Relay::ToString(DWORD value)
{
	char buffer[11]; // Enough to hold all digits of a DWORD
	snprintf(buffer, sizeof(buffer), "%lu", value); // NOLINT(cert-err33-c)
	return std::string(buffer);
}

int64_t Relay::GetPctHP(const PlayerClient* pSpawn)
{
	return pSpawn->HPMax == 0 ? 0 : pSpawn->HPCurrent * 100 / pSpawn->HPMax;
}

std::string Relay::GetLeaderName()
{
	char nameBuffer[MAX_STRING] = { 0 };
	std::string leaderName;
	if (pLocalPC->Group)
	{
		CGroupMember* pLeader = pLocalPC->Group->GetGroupLeader();
		strcpy_s(nameBuffer, pLeader->pSpawn->Name);
		CleanupName(nameBuffer, MAX_STRING, false, false);
		return nameBuffer;
	}

	return "Ungrouped";
}

std::string Relay::GetCharacterKey()
{
	//Buffer for names
	char nameBuffer[MAX_STRING] = { 0 };

	const std::string serverName = GetServerShortName();

	strcpy_s(nameBuffer, MAX_STRING, pLocalPC->Name);
	const std::string characterName = CleanupName(nameBuffer, MAX_STRING, false, false);
	memset(nameBuffer, 0, MAX_STRING);

	return  serverName + ":" + GetLeaderName() + ":characters:" + characterName;
}

// Initialize the reference in the constructor's initialization list
Relay::Relay(const std::string& connectionString, const RelayTimings& timings)
	: _timings(timings)
{
	_redis = std::make_unique<sw::redis::Redis>(connectionString);
	_spawnScriptSHA = _redis->script_load(_spawnScript);
	_spawnHPScriptSHA = _redis->script_load(_spawnHPScript);
	_spawnBuffScriptSHA = _redis->script_load(_spawnBuffsScript);
}
