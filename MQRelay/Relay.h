#pragma once
#include <sw/redis++/redis.h>
#include <sw/redis++/queued_redis.h>
#include <mq/Plugin.h>
#include <chrono>


//All frequencies are in milliseconds
//All Expire times are in seconds
struct RelayTimings
{
	unsigned CharacterStatsUpdateFrequency = 6000;
	unsigned CharacterStateUpdateFrequency = 100;
	unsigned SpawnsUpdateFrequency = 6000;
	unsigned XTargetUpdateFrequency = 100;
	unsigned BuffUpdateFrequency = 1000;
	unsigned CharacterExpireTime = 60;
	unsigned CharacterBuffExpireTime = 60;
	unsigned SpawnExpireTime = 60;
	unsigned XTargetExpireTime = 60;
	unsigned GroupExpireTime = 60;
};

class Relay
{
public:

	void Update();
	void LoadSpellData(sw::redis::Pipeline& pipeline, const std::string& key, const eqlib::EQ_Affect& buff) const;
	explicit Relay(const std::string& connectionString,const RelayTimings& timings);
private:
	static std::string GetCombatState();
	static std::string ToString(int value);
	static std::string ToString(uint8_t value);
	static std::string ToString(float value, int precision);
	static std::string ToString(unsigned value);
	static std::string ToString(DWORD value);
	static int64_t GetPctHP(const PlayerClient* pSpawn);
	static void UpdateCharacterState(sw::redis::Pipeline& pipeline);
	static void UpdateCharacterStats(sw::redis::Pipeline& pipeline);
	void UpdateGroupData(sw::redis::Pipeline& pipeline) const;
	void UpdateBuffData(sw::redis::Pipeline& pipeline) const;
	void UpdateXTargetData(sw::redis::Pipeline& pipeline, long long time) const;
	void UpdateSpawnData(sw::redis::Pipeline& pipe, long long time) const;
	const RelayTimings& _timings;  // NOLINT(cppcoreguidelines-avoid-const-or-ref-data-members)
	static std::string GetLeaderName();
	static std::string GetCharacterKey();
	std::unique_ptr<sw::redis::Redis> _redis;
	long long _characterStatsUpdateTime = 0;
	long long _characterStateUpdateTime = 0;
	long long _xTargetsUpdateTime = 0;
	long long _buffsUpdateTime = 0;
	long long _spawnsUpdateTime = 0;
	std::string _spawnScriptSHA;
	std::string _spawnHPScriptSHA;
	std::string _spawnBuffScriptSHA;
	const std::string _spawnBuffsScript = // NOLINT(cppcoreguidelines-avoid-const-or-ref-data-members)
						R"( 
						--stored in zone:spawns:123:buffs:1
						local key           = KEYS[1]
						local buffStaleness = tonumber(redis.call('HGET', key, 'Staleness')) or math.huge
						local buffUpdated   = tonumber(redis.call('HGET', key, 'Updated')) or 0
						local buffSpellId   = tonumber(redis.call('HGET', key, 'SpellId')) or -1
						local staleness     = tonumber(ARGV[1])
						local currentTime   = tonumber(ARGV[2])
						local spellId       = tonumber(ARGV[3])
						local duration = tonumber(ARGV[5])

						--if the data is one second or more stale
						--or the spell id is different
						--or it hasn't been updated in a second
						if (buffStaleness - staleness > 1000) or buffSpellId ~= spellId or currentTime - buffUpdated > 1000 then
						    redis.call('HSET', key, "SpellId", spellId,"CasterName", ARGV[4],"Duration", duration,'Staleness', staleness,'Updated', currentTime)
						end
						redis.call('EXPIRE', key, math.ceil(duration / 1000)+1)
					)";
	const std::string _spawnHPScript = // NOLINT(cppcoreguidelines-avoid-const-or-ref-data-members)
						R"(
						local key = KEYS[1]

						--HPUpdateFrom is magic numbers, XTarget = 1, TargetOfTarget = 2, Target = 3
						local updateHPFrom = tonumber(redis.call('HGET', key, 'HPUpdateFrom')) or 0
						local lastHPUpdated = tonumber(redis.call('HGET', key, 'LastHPUpdated') or 0)
						local currentTime = tonumber(ARGV[1])
						local newHPFrom = tonumber(ARGV[2])
						local expireTime = tonumber(ARGV[3])
						local HPValue = tonumber(ARGV[4])

						-- Update the hash if the conditions are met
						if (newHPFrom > updateHPFrom) or (currentTime - lastHPUpdated) > 500 then
						    redis.call('HSET',key,"PercentHPs",HPValue)
						    -- Update the 'Distance' and 'LastUpdated' fields
						    redis.call('HSET', key, 'HPUpdateFrom', newHPFrom)
						    redis.call('HSET', key, 'LastHPUpdated', currentTime)
						end
						redis.call('EXPIRE', key, expireTime)
						)";
	const std::string _spawnScript = // NOLINT(cppcoreguidelines-avoid-const-or-ref-data-members)
						R"(
						-- KEYS[1]: Full key of the format "<zoneName>:spawns:<spawnId>"
					    -- ARGV[1]: Current time (timestamp)
					    -- ARGV[2]: New distance
					    -- ARGV[3...]: New data fields in pairs

					    local key = KEYS[1]

					    -- Fetch the current distance and last updated timestamp from the hash
					    local currentDistance = tonumber(redis.call('HGET', key, 'Distance') or math.huge)
					    local lastUpdated = tonumber(redis.call('HGET', key, 'LastUpdated') or 0)
					    local currentTime = tonumber(ARGV[1])
					    local newDistance = tonumber(ARGV[2])
					    local expireTime = tonumber(ARGV[3])

					    -- Determine if the incoming data is more recent and closer or within the accurate range
					    local shouldUpdate = false
					    if (newDistance <= 200 and currentDistance <= 200) then
					        --both are within update distance in game
					        --So if the old one is half a second old we'll update it
					        if currentTime - lastUpdated > 500 then
					            shouldUpdate = true
					        end
					    elseif newDistance<=200 then
					        --old one had to have been greater than 200 units away, so we'll update with this data
					        shouldUpdate = true
					    elseif math.abs(newDistance - currentDistance)>200 then
					        --the old distance is a good deal further away, we'll override it
					        shouldUpdate = true
					    end

					    -- Update the hash if the conditions are met
					    if shouldUpdate then
					        -- Loop through the ARGV table to update the fields, starting from the third argument
					        for i = 4, #ARGV - 1, 2 do
					            redis.call('HSET', key, ARGV[i], ARGV[i + 1])
					        end
					        -- Update the 'Distance' and 'LastUpdated' fields
					        redis.call('HSET', key, 'Distance', newDistance)
					        redis.call('HSET', key, 'LastUpdated', currentTime)
					    end

					    redis.call('EXPIRE',key,expireTime)
						)";
};
