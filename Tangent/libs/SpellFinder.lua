---@type mq
MQ = MQ or require("mq")
---@type CharacterType
Me = Me or MQ.TLO.Me
require("libs.Helpers.StringFunctions")

---@class SpellFinderSpell
---@field Spell AltAbilityType|SpellType
---@field SpellType string "'Gem' or 'Alt'"
---@param spell AltAbilityType|SpellType
---@param spellType string "'Gem' or 'Alt'"
---@return SpellFinderSpell
function SpellFinderSpell(spell, spellType)
    return {
        Spell = spell,
        SpellType = spellType
    }
end

local maxBookSlots = 960
---@class SpellFinder
---@field Spells table<string,SpellFinderSpell[]>
local spellFinder = {}
spellFinder.targetTypes = {
    Target_AE_No_Players_Pets = "TargetedAE",
    ["Single Friendly (or Target's Target"] = "Friendly",
    ["Pet Owner"] = "PetOwner",
    ["Target of Target"] = "TargetOfTarget",
    ["Free Target"] = "Free",
    Beam = "Beam",
    ["Single in Group"] = "SingleInGroup",
    ["Directional AE"] = "Cone",
    ["Group v2"] = "Group",
    ["AE PC v2"] = "FriendlyAE",
    ["No Pets"] = "NoPet",
    Pet2 = "Pet",
    ["Caster PB NPC"] = "EnemyPBAE",
    ["Caster PB PC"] = "FriendlyPBAE",
    ["Special Muramites"] = "Muramites",
    Chest = "Chest",
    Hatelist2 = "Hatelist",
    Hatelist = "Hatelist",
    ["AE Summoned"] = "SummonedAE",
    ["AE Undead"] = "UndeadAE",
    ["Targeted AE Tap"] = "TargetAETap",
    ["Uber Dragons"] = "UberDragon",
    ["Uber Giants"] = "UberGiant",
    Plant = "Plant",
    Corpse = "Corpse",
    Pet = "Pet",
    LifeTap = "Lifetap",
    Summoned = "Summoned",
    Undead = "Undead",
    Animal = "Animal",
    ["Targeted AE"] = "TargetedAE",
    Self = "Self",
    Single = "Single",
    ["PB AE"] = "PBAE",
    ["Group v1"] = "Group",
    ["AE PC v1"] = "FriendlyAE",
    ["Line of Sight"] = "LineOfSight",
    Unknown = "Unknown"
}
spellFinder.cureTypes = {
    Poison = 36,
    Curse = 116,
    Disease = 35,
    Corruption = 369,
    [36] = "Poison",
    [116] = "Curse",
    [35] = "Disease",
    [369] = "Corruption"
}
spellFinder.resistTypes = {
    Magic = "Magic",
    Disease = "Disease",
    Poison = "Poison",
    Fire = "Fire",
    Cold = "Cold",
    Unresistable = "Unresistable",
    Chromatic = "Chromatic",
    Corruption = "Corruption"
}
spellFinder.resistBuffTypes = {
    Magic = 50,
    Disease = 49,
    Poison = 48,
    Fire = 46,
    Cold = 47,
    Corruption = 370,
    [49] = "Disease",
    [50] = "Magic",
    [46] = "Fire",
    [370] = "Corruption",
    [47] = "Cold",
    [48] = "Poison"
}
spellFinder.Spells = {}
spellFinder.Gui = {
    baseFlags = bit.bor(bit.bor(bit.lshift(1, 7), bit.lshift(1, 6)), bit.lshift(1, 11)),
    nodeClicked = -1
}
spellFinder.TabName = "Spells"
---@param self SpellFinder
spellFinder.RenderTab = function(self, gui)
    self.Gui.TabSelected = ImGui.BeginTabItem(self.TabName)
    if self.Gui.TabSelected then
        local xSize, ySize = ImGui.GetContentRegionAvail()
        ImGui.BeginChild("Spell List", xSize * 0.48, ySize, true)
        self:__renderTree(gui)
        ImGui.EndChild()
        if self.Gui.nodeClicked > 0 then
            ImGui.SameLine()
            ImGui.BeginChild("Selected Spell", xSize * 0.48, ySize, true)
            ImGui.Text(string.format("The selected spell is %s", self.Gui.selectedSpell.Spell.Name()))
            ImGui.EndChild()
        end
        ImGui.EndTabItem()
    end
end

spellFinder.__renderTree = function(self, gui)
    local totalCount = 0
    for label, spellList in pairs(spellFinder.Spells) do
        totalCount = totalCount + 1
    end
    local count = 0
    local index = 0
    for label, spellList in pairs(spellFinder.Spells) do
        local nodeOpen = ImGui.TreeNodeEx(label, self.Gui.baseFlags)
        if nodeOpen then
            for i, spell in ipairs(spellList) do
                count = (index * totalCount) + i
                local nodeFlags = bit.bor(bit.bor(self.Gui.baseFlags, bit.lshift(1, 8)), bit.lshift(1, 3))
                if self.Gui.nodeClicked == count then
                    nodeFlags = bit.bor(nodeFlags, bit.lshift(1, 0))
                end
                ImGui.TreeNodeEx(spell.Spell.Name(), nodeFlags)
                if ImGui.IsItemClicked() and not ImGui.IsItemToggledOpen() then
                    if self.Gui.nodeClicked == count then
                        self.Gui.nodeClicked = -1
                        self.Gui.selectedSpell = nil
                    else
                        self.Gui.nodeClicked = count
                        self.Gui.selectedSpell = spell
                    end
                end
            end
            ImGui.TreePop()
            index = index + 1
        end
    end
end

function spellFinder.__loadAlternateAdvancements()
    local className = Me.Class.ShortName()
    local aa = MQ.TLO.AltAbility
    local altSpellsTable = {}
    local result
    ---Checks if the character has the provided abilityName, if so adds it to altSpellsTable
    ---@param spellClassification string
    ---@param abilityName string|number
    ---@param minRank? number
    ---@return SpellFinderSpell|nil
    local function checkAltAbility(spellClassification, abilityName, minRank)
        minRank = minRank or 1
        if aa(abilityName)() and aa(abilityName).Rank() >= minRank then
            altSpellsTable[spellClassification] = SpellFinderSpell(aa(abilityName), 'Alt')
        end
    end
    checkAltAbility("TargetedAESnare", "Atol's Shackles")
    checkAltAbility("AttackPet", "Call of Xuzl")
    checkAltAbility("Jolt", "Concussion")
    checkAltAbility("SelfShielding", "Etherealist's Unity")
    checkAltAbility("FireNuke", "Force of Flame")
    checkAltAbility("ColdNuke", "Force of Ice")
    checkAltAbility("MagicNuke", "Force of Will")
    checkAltAbility("Root", "Frost Shackles")
    checkAltAbility("Harvest", "Harvest of Druzzil")
    checkAltAbility("Familiar", "Improved Familiar")
    checkAltAbility("Jolt", "Mind Crash")
    checkAltAbility("Escape", "A Hole In Space")
    checkAltAbility("Jolt", "Arcane Whisper")
    checkAltAbility("SelfMeleeGuard", "Dimensional Shield")
    checkAltAbility("Evac", "Exodus")
    checkAltAbility("GroupInvisibility", "Group Perfected Invisibility")
    checkAltAbility("GroupUndeadInvisibility", "Group Perfected invisibility to Undead")
    checkAltAbility("Invisibility", "Perfected Invisibility")
    checkAltAbility("UndeadInvisibility", "Perfected invisibility to Undead")
    checkAltAbility("SelfUndeadInvisibility", "Innate Invis to Undead")
    checkAltAbility("Levitation", "Perfected Levitation")
    checkAltAbility("Escape", "Divine Peace")
    checkAltAbility("SelfCure", "Purified Spirits")
    checkAltAbility("RadiantCure", "RadiantCure")
    checkAltAbility("GroupHeal", "Beacon of Life")
    checkAltAbility("TargetDA", "Bestow Divine Aura")
    checkAltAbility("Root", "Blessed Chains")
    checkAltAbility("TargetEscape", "Blessings of Sanctuary")
    checkAltAbility("OhShitHeal", "Burst of Life")
    checkAltAbility("AttackPet", "Celestial Hammer")
    checkAltAbility("GroupDurationheal", "Celestial Regeneration")
    checkAltAbility("HPBalance", "Divine Arbitration")
    checkAltAbility("SelfDA", "Divine Aura")
    checkAltAbility("HealWard", "Exquisite Benediction")
    checkAltAbility("DurationHeal", "Focused Celestial Regeneration")
    checkAltAbility("GroupCure", "Group Purify Soul")
    checkAltAbility("Cure", "Purify Soul")
    checkAltAbility("SelfShielding", "Saint's Unity")
    checkAltAbility("UndeadDot", "Turn Undead")
    checkAltAbility("Harvest", "Veturika's Perseverance")
    checkAltAbility("CureWard", "Ward of Purity")
    checkAltAbility("Yaulp", "Yaulp")
    checkAltAbility("Durationheal", "Abundant Healing")
    checkAltAbility("PetDA", "Companion's Intervening Divine Aura")
    checkAltAbility("GroupShink", "Group Shrink")
    checkAltAbility("Escape", "Inconspicuous Totem")
    checkAltAbility("GroupSow", "Lupine Spirit")
    checkAltAbility("ResistDebuff", "Malaise")
    checkAltAbility("Shrink", "Shrink")
    checkAltAbility("TargetedAEResistDebuff", "Wind of Malaise")
    checkAltAbility("GroupDurationheal", "Ancestral Aid")
    checkAltAbility("SelfMeleeGuard", "Ancestral Guard")
    checkAltAbility("HealWard", "Call of the Ancients")
    checkAltAbility("Canni", "Cannibalization")
    checkAltAbility("TargetCure", "Improved Pure Spirit")
    checkAltAbility("GroupHaste", "Talisman of Celerity")
    checkAltAbility("GroupHaste", "Pact of the Wolf")
    checkAltAbility("OhShitHeal", "Soothsayer's Intervention")
    checkAltAbility("Slow", "Turgur's Swarm")
    checkAltAbility("TargetedAESlow", "Turgur's Virulent Swarm")
    checkAltAbility("Heal", "Union of Spirits")
    checkAltAbility("SpellProc", "Visionary's Unity")
    checkAltAbility("TargetEscape", "Friendly Statis")
    checkAltAbility("Twincast", "Improved Twincast")
    checkAltAbility("Escape", "Self Statis")
    checkAltAbility("BeamMez", "Beam of Slumber")
    checkAltAbility("PBAEResistDebuff", "Bite of Tashani")
    checkAltAbility("DecoyPet", "Doppelganger")
    checkAltAbility("SelfRune", "Eldritch Rune")
    checkAltAbility("TargetedAESlow", "Enveloping Helix")
    checkAltAbility("Harvest", "Gather Mana")
    checkAltAbility("SpellShield", "Glyph Spray")
    checkAltAbility("Mez", "Noctambulate")
    checkAltAbility("SelfShielding", "Orator's Unity")
    checkAltAbility("DecoyPet", "Phantasmal Opponent")
    checkAltAbility("GroupRune", "Reactive Rune")
    checkAltAbility("Slow", "Slowing Helix")
    checkAltAbility("SelfMeleeGuard", "Veil of Mindshadow")
    checkAltAbility("Escape", "Drape of Shadows")
    checkAltAbility("PetCanni", "Elemental Conversion")
    checkAltAbility("ElementalForm", "ElementalForm")
    checkAltAbility("MagicNuke", "Force of Elements")
    checkAltAbility("PetMeleeGuard", "Host in the Shell")
    checkAltAbility("AttackPet", "Host of the Elements")
    checkAltAbility("AttackPet", "Servant of Ro")
    checkAltAbility("SelfShielding", "Thaumature's Unity")
    checkAltAbility("SummonedDot", "Turn Summoned")
    checkAltAbility("SelfInvisibility", "Cloak of Shadows")
    checkAltAbility("FeignDeath", "Death Peace")
    checkAltAbility("Escape", "Death's Effigy")
    checkAltAbility("SnareDot", "Encroaching Darkness")
    checkAltAbility("SelfDA", "Harmshield")
    checkAltAbility("Canni", "Death Bloom")
    checkAltAbility("LifeTap", "Dying Grasp")
    checkAltAbility("SelfCure", "Embracy the Decay")
    checkAltAbility("Twincast", "Heretic's Twincast")
    checkAltAbility("SelfShielding", "Mortifier's Unity")
    checkAltAbility("AttackPet", "Rise of Bones")
    checkAltAbility("ResistDebuff", "Scent of Thule")
    checkAltAbility("AttackPet", "Swarm of Decay")
    checkAltAbility("AttackPet", "Wake the Dead")
    checkAltAbility("Jolt", "Ageless Enmity")
    checkAltAbility("TauntWard", "Projection of Doom")
    checkAltAbility("ShieldBlock", "Shield Flash")
    checkAltAbility("AttackPet", "Chattering Bones")
    checkAltAbility("SelfShielding", "Dark Lord's Unity (Azia)")
    checkAltAbility("SelfShielding", "Dark Lord's Unity (Beza)")
    checkAltAbility("TargetedAEJolt", "Explosion of Hatred")
    checkAltAbility("TargetedAEJolt", "Explosion of Spite")
    checkAltAbility("Jolt", "Hate's Attraction")
    checkAltAbility("LifeTap", "Leech Touch")
    checkAltAbility("SelfCure", "Purity of Death")
    checkAltAbility("BeamJolt", "Stream of Hatred")
    checkAltAbility("ManaTap", "Thought Leech")
    checkAltAbility("Jolt", "Veil of Darkness")
    checkAltAbility("GroupManaTap", "Vicious Bite of Chaos")
    checkAltAbility("AggroVisage", "Voice of Thule")
    checkAltAbility("Escape", "Falsified Death")
    checkAltAbility("FeignDeath", "Playing Possum")
    checkAltAbility("AttackPet", "Attack of the Warders")
    checkAltAbility("Jolt", "Chameleon Strike")
    checkAltAbility("Canni", "Consumption of Spirit")
    checkAltAbility("ReverseProc", "Enduring Frenzy")
    checkAltAbility("KillProc", "Feralist's Unity")
    checkAltAbility("SelfCure", "Nature's Salve")
    checkAltAbility("SelfAtkBuff", "Pact of the Wurine")
    checkAltAbility("Jolt", "Roar of Thunder")
    checkAltAbility("Slow", "Sha's Reprisal")
    checkAltAbility("Escape", "Cover Tracks")
    checkAltAbility("Snare", "Entrap")
    checkAltAbility("Sow", "Spirit of Eagles")
    checkAltAbility("Heal", "Convergence of Spirits")
    checkAltAbility("OffensiveFireArrowProc", "Flaming Arrows")
    checkAltAbility("GroupAtkBuff", "Group Guardian of the Forest")
    checkAltAbility("SelfAtkBuff", "Guardian of the Forest")
    checkAltAbility("OffensivePoisonArrowProc", "Poison Arrows")
    checkAltAbility("SelfShielding", "Winstalker's Unity (Azia)")
    checkAltAbility("SelfShielding", "Winstalker's Unity (Beza)")
    checkAltAbility("ACDebuff", "Blessing of Ro")
    checkAltAbility("GroupHeal", "Blessing of Tunare")
    checkAltAbility("MagicNuke", "Nature's Bolt")
    checkAltAbility("HealWard", "Nature's Boon")
    checkAltAbility("FireNuke", "Nature's Fire")
    checkAltAbility("ColdNuke", "Nature's Frost")
    checkAltAbility("AttackPet", "Nature's Guardian")
    checkAltAbility("AttackPet", "Spirits of Nature")
    checkAltAbility("GroupOhShitHeal", "Wildtender's Survival")
    checkAltAbility("SelfShielding", "Wildtender's Unity")
    checkAltAbility("Escape", "Fading Memories")
    checkAltAbility("StunNuke", "Boastful Bellow")
    checkAltAbility("Mez", "Dirge of the Sleepwalker")
    checkAltAbility("DecoyPet", "Lyrical Prankster")
    checkAltAbility("Selos", "Selo's Sonata")
    checkAltAbility("AttackPet", "Song of Stone")
    checkAltAbility("StoneThrow", "Sonic Displacement")
    checkAltAbility("StoneThrow", "Sonic Disturbance")
    checkAltAbility("BeamMagicNuke", "Vainglorious Shout")
end
function spellFinder.__prependTargetType(spell, spellType)
    if spell.TargetType() ~= spellFinder.targetTypes.Single and (spell.TargetType() ~= spellFinder.targetTypes.Corpse) then
        return (spellFinder.targetTypes[spell.TargetType()] .. spellType)
    end
    return spellType
end

---Compares two spells of the same classification
---@param spellClassification string
---@param spell SpellFinderSpell
function spellFinder.__placeSpell(spellClassification, spell)
    if not spellFinder.Spells[spellClassification] then
        spellFinder.Spells[spellClassification] = {}
        table.insert(spellFinder.Spells[spellClassification], spell)
    else
        if spell.SpellType == "Alt" then
            table.insert(spellFinder.Spells[spellClassification], spell)
        else
            if "Jolt" == spellClassification and
                (Me.Class.ShortName() == "WAR" or Me.Class.ShortName() == "PAL" or Me.Class.ShortName() == "SHD") then
                ---@type SpellFinderSpell[]
                local spellList = spellFinder.Spells[spellClassification]
                ---@type SpellFinderSpell
                local worstSpell = spell
                local worstIndex = -1
                local count = 0;
                for index, value in ipairs(spellList) do
                    if value.SpellType == "Gem" then
                        count = count + 1
                        if worstSpell.Spell.HateGenerated() > value.Spell.HateGenerated() then
                            worstSpell = value
                            worstIndex = index
                        elseif worstSpell.Spell.HateGenerated() == value.Spell.HateGenerated() then
                            if worstSpell.Spell.Mana() < value.Spell.Mana() then
                                worstSpell = value
                                worstIndex = index
                            elseif worstSpell.Spell.Mana() == value.Spell.Mana() then
                                if worstSpell.Spell.RecastTime() < value.Spell.RecastTime() then
                                    worstSpell = value
                                    worstIndex = index
                                elseif worstSpell.Spell.RecastTime() == value.Spell.RecastTime() then
                                    if worstSpell.Spell.Level() < value.Spell.Level() then
                                        worstSpell = value
                                        worstIndex = index
                                    end
                                end
                            end

                        end
                    end
                end
                if (count >= 3 and worstIndex ~= -1) then
                    spellFinder.Spells[spellClassification][worstIndex] = spell
                elseif count < 3 then
                    table.insert(spellFinder.Spells[spellClassification], spell)
                end
            elseif "Mez" == spellClassification or "Stun" == spellClassification then
                ---@type SpellFinderSpell[]
                local spellList = spellFinder.Spells[spellClassification]
                ---@type SpellFinderSpell
                local worstSpell = spell
                local worstIndex = -1
                local count = 0;
                for index, value in ipairs(spellList) do
                    if value.SpellType == "Gem" then
                        count = count + 1
                        if worstSpell.Spell.Max(1)() > value.Spell.Max(1)() then
                            worstSpell = value
                            worstIndex = index
                        elseif worstSpell.Spell.Max(1)() == value.Spell.Max(1)() then
                            if worstSpell.Spell.Duration() > value.Spell.Duration() then
                                worstSpell = value
                                worstIndex = index
                            elseif worstSpell.Spell.Duration() == value.Spell.Duration() then
                                if worstSpell.Spell.RecastTime() < value.Spell.RecastTime() then
                                    worstSpell = value
                                    worstIndex = index
                                elseif worstSpell.Spell.RecastTime() == value.Spell.RecastTime() then
                                    if worstSpell.Spell.MyCastTime() < value.Spell.MyCastTime() then
                                        worstSpell = value
                                        worstIndex = index
                                    elseif worstSpell.Spell.MyCastTime() == value.Spell.MyCastTime() then
                                        if worstSpell.Spell.Mana() < value.Spell.Mana() then
                                            worstSpell = value
                                            worstIndex = index
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if (count >= 3 and worstIndex ~= -1) then
                    spellFinder.Spells[spellClassification][worstIndex] = spell
                elseif count < 3 then
                    table.insert(spellFinder.Spells[spellClassification], spell)
                end
            else
                ---@type SpellFinderSpell[]
                local spellList = spellFinder.Spells[spellClassification]
                for index, value in ipairs(spellList) do
                    if value.SpellType == "Gem" then
                        if spell.Spell.Level() > value.Spell.Level() then
                            spellList[index] = spell
                        end
                        break
                    end
                end
            end
        end
    end
end

function spellFinder.LoadSpells()
    local startTime = os.clock()
    local classificationCount = 0
    local classificationTotalTime = 0
    local placeCount = 0
    local placeTotalTime = 0
    local endTime = 0
    for i = 1, maxBookSlots, 1 do
        ---@type SpellType
        local spell = Me.Book(i)
        if spell.ID() then
            if spell then
                classificationCount = classificationCount + 1
                local w1 = os.clock()
                local spellClassification = spellFinder.ClassifySpell(spell)
                classificationTotalTime = classificationTotalTime + ((os.clock()) - w1)
                if spellClassification then
                    placeCount = placeCount + 1
                    w1 = os.clock()
                    --spellFinder.__placeSpell(spellClassification, SpellFinderSpell(spell, "Gem"))
                    placeTotalTime = placeTotalTime + (os.clock() - w1)
                else
                    -- print(string.format("Unable to classify %s->%s->%s",spell.Category(),spell.Subcategory(),spell.Name()))
                end
            end
        end
    end
    print("Done after ",os.clock() - startTime)
    print(string.format("Processed %d spells in %d seconds (avg %d), placed a total of %d spells in %d seconds (avg %d)",classificationCount,classificationTotalTime,classificationTotalTime/classificationCount,placeCount,placeTotalTime,placeTotalTime/placeCount))
    local altSpells = spellFinder.__loadAlternateAdvancements()
    -- print("Found the following spell classifications")
    -- for k, v in pairs(spellFinder.Spells) do
    --     for index, value in ipairs(v) do
    --         print("\a-g", k, "[", index, "]", "\ax:\a-y", value.Spell())
    --     end
    -- end
end

---@return string
---@param stackingGroup number
function spellFinder.FindDotType(stackingGroup)
    local dotTypes = {
        [38] = "ChaoticBoon",
        [40] = "ManaFlare",
        [41] = "ManaStorm",
        [86] = "Scourge",
        [82] = "Immolate",
        [81] = "StingingSwarm",
        [91] = "EnvenomedBreath",
        [63] = "Sermon",
        [146] = "Splurt",
        [65] = "Smother",
        [131] = "FesteringDarkness",
        [60] = "TureptaBlood",
        [61] = "Fever",
        [90] = "Bane",
        [80] = "Vengeance",
        [68] = "LocustSwarm",
        [130] = "Constriction",
        [133] = "Blood",
        [136] = "Rot",
        [137] = "Grip",
        [143] = "Nightmare",
        [141] = "Haze",
        [138] = "Pyre",
        [139] = "DreadPyre",
        [142] = "Venom",
        [92] = "Nectar",
        [64] = "Mind",
        [83] = "Nature",
        [140] = "Shadow",
        [135] = "Impurity",
        [132] = "Blight",
        [84] = "Moonbeam",
        [88] = "Pandemic",
        [66] = "Constriction",
        [85] = "Chill",
        [87] = "Affliction",
        [89] = "Curse",
        [62] = "Edoth",
        [147] = "Fates",
        [157] = "DiseaseChant",
        [158] = "FrostChant ",
        [159] = "PoisonChant",
        [160] = "FlameChant",
        [31] = "Challenge"
    }
    return dotTypes[stackingGroup]
end

---@param spell SpellType
---@return any
function spellFinder.ClassifySpell(spell)
    local spellClassification
    local ignoreTargetType = false
    local spellTable = {
        Heals = {
            Heals = function()
                spellClassification = "Heal"
                if spell.NumEffects() > 1 then
                    for i = 2, spell.NumEffects(), 1 do
                        local attrib = (spell.Attrib(i))()
                        if attrib == spellFinder.cureTypes.Poison or (attrib == spellFinder.cureTypes.Disease) or
                            (attrib == spellFinder.cureTypes.Corruption) then
                            spellClassification = "HealCure"
                            break
                        end
                    end
                end
                if spell.CastTime() > 7500 then
                    spellClassification = ("Complete" .. spellClassification)
                elseif spell.CastTime() < 2000 then
                    spellClassification = "QuickHeal"
                end
            end,
            Cure = function()
                spellClassification = "Cure"
                local curesPoison = false
                local curesDisease = false
                local curesCurse = false
                local curesCorruption = false
                for i = 1, spell.NumEffects(), 1 do
                    local attrib = (spell.Attrib(i))()
                    if attrib == spellFinder.cureTypes.Poison then
                        curesPoison = true
                    end
                    if attrib == spellFinder.cureTypes.Disease then
                        curesDisease = true
                    end
                    if attrib == spellFinder.cureTypes.Curse then
                        curesCurse = true
                    end
                    if attrib == spellFinder.cureTypes.Corruption then
                        curesCorruption = true
                    end
                end
                if curesPoison and curesDisease and curesCurse and curesCorruption then
                    spellClassification = (spellClassification .. "All")
                else
                    if curesPoison then
                        spellClassification = (spellClassification .. "Poison")
                    end
                    if curesDisease then
                        spellClassification = (spellClassification .. "Disease")
                    end
                    if curesCurse then
                        spellClassification = (spellClassification .. "Curse")
                    end
                    if curesCorruption then
                        spellClassification = (spellClassification .. "Corruption")
                    end
                end
            end,
            ["Duration Heals"] = function()
                spellClassification = "DurationHeal"
            end,
            Resurrection = function()
                spellClassification = "Rez"
            end,
            ["Quick Heal"] = function()
                spellClassification = "QuickHeal"
                if (spell.Restrictions(1))():startsWith("HP Between") or (spell.Name() == "Eleventh-Hour") or
                    (spell.Name() == "Twelfth Night") then
                    spellClassification = "OhShitHeal"
                end
            end,
            Delayed = function()
                spellClassification = "DelayedHeal"
            end,
            Misc = function()
                if spell.Name():endsWith("Contravention") then
                    spellClassification = "Contravention"
                elseif spell.Name():endsWith("Intervention") then
                    spellClassification = "Intrervention"
                end
            end,
            Stamina = function(spell)
            end,
            ["Mana Flow"] = function(spell)
                if Me.Class.ShortName() == "MAG" or Me.Class.ShortName() == "WIZ" then
                    ignoreTargetType = true
                    spellClassification = "Harvest"
                end
            end,
            ["Life Flow"] = function(spell)
            end
        },
        ["HP Buffs"] = {
            ["HP type one"] = function()
                spellClassification = "HPTypeOne"
            end,
            Shielding = function()
                spellClassification = "Shielding"
            end,
            Temporary = function()
                spellClassification = "TemporaryHP"
            end,
            Symbol = function()
                spellClassification = "Symbol"
            end,
            ["HP type two"] = function()
                spellClassification = "HPTypeTwo"
            end,
            Aegolism = function()
                spellClassification = "Aego"
            end,
            Strength = function()
                spellClassification = "HPStrength"
            end
        },
        ["Statistic Buffs"] = {
            Dexterity = function()
                spellClassification = "DexBuff"
            end,
            Strength = function()
                spellClassification = "StrBuff"
            end,
            Agility = function()
                spellClassification = "AgiBuff"
            end,
            Stamina = function()
                spellClassification = "StaBuff"
            end,
            ["Armor Class"] = function()
                spellClassification = "ACBuff"
            end,
            Charisma = function()
                spellClassification = "ChaBuff"
            end,
            ["Resist Buff"] = function()
                local hasFireResist = false
                local hasColdResist = false
                local hasMagicResist = false
                local hasPoisonResist = false
                local hasDiseaseResist = false
                local hasCorruptionResist = false
                local effectCount = spell.NumEffects()
                for i = 1, effectCount, 1 do
                    if (spell.Attrib(i)() == spellFinder.resistBuffTypes.Magic) then
                        hasMagicResist = true
                    end
                    if (spell.Attrib(i)() == spellFinder.resistBuffTypes.Disease) then
                        hasDiseaseResist = true
                    end
                    if (spell.Attrib(i)() == spellFinder.resistBuffTypes.Poison) then
                        hasPoisonResist = true
                    end
                    if (spell.Attrib(i)() == spellFinder.resistBuffTypes.Fire) then
                        hasFireResist = true
                    end
                    if (spell.Attrib(i)() == spellFinder.resistBuffTypes.Cold) then
                        hasColdResist = true
                    end
                    if (spell.Attrib(i)() == spellFinder.resistBuffTypes.Corruption) then
                        hasCorruptionResist = true
                    end
                end
                spellClassification = ""

                if hasColdResist then
                    spellClassification = spellClassification .. "Cold"
                end
                if hasCorruptionResist then
                    spellClassification = spellClassification .. "Corruption"
                end
                if hasDiseaseResist then
                    spellClassification = spellClassification .. "Disease"
                end
                if hasFireResist then
                    spellClassification = spellClassification .. "Fire"
                end
                if hasMagicResist then
                    spellClassification = spellClassification .. "Magic"
                end
                if hasPoisonResist then
                    spellClassification = spellClassification .. "Poison"
                end
                spellClassification = spellClassification .. "Resist"
            end,
            Attack = function()
                spellClassification = "AttackBuff"
            end,
            ["Wisdom/Intelligence"] = function()
                spellClassification = "MentalBuff"
            end,
            Shielding = function()
                spellClassification = "Shielding"
            end,
            Misc = function()
                if spell.Name == "Silent Piety" then
                    spellClassification = "SpellResist"
                end
            end,
            ["Fizzle Rate"] = function()
                spellClassification = "FizzleReduction"
            end,
            Mana = function()
                spellClassification = "ManaBuff"
            end
        },
        ["Direct Damage"] = {
            Fire = function()
                spellClassification = "FireNuke"
                if Me.Class.ShortName() == "WIZ" and spell.Name():find("Lure") then
                    spellClassification = "Lure" .. spellClassification
                elseif Me.Class.ShortName() == "WIZ" and spell.Name():startsWith("Wildmagic") then
                    spellClassification = "WildmagicNuke"
                elseif spell.CastTime() <= 2000 then
                    spellClassification = "Quick" .. spellClassification
                end
            end,
            Cold = function()
                spellClassification = "ColdNuke"
                if Me.Class.ShortName() == "WIZ" then
                    if spell.Name():find("Lure") then
                        spellClassification = "Lure" .. spellClassification
                    elseif spell.Name():endsWith("Snap") then
                        spellClassification = "ColdSnap"
                    elseif spell.Name() == "Mindfreeze" then
                        spellClassification = "ColdJolt"
                    elseif spell.CastTime() <= 2000 then
                        spellClassification = "Quick" .. spellClassification
                    end
                elseif spell.CastTime() <= 2000 then
                    spellClassification = "Quick" .. spellClassification
                end
            end,
            Poison = function()
                spellClassification = "PoisonNuke"
            end,
            Magic = function()
                if Me.Class.ShortName() == "CLR" and spell.Name():startsWith("Glorious") then
                    spellClassification = "TwincastNuke"
                else
                    spellClassification = "MagicNuke"
                end
                if Me.Class.ShortName() == "WIZ" and spell.Name():find("Lure") then
                    spellClassification = "Lure" .. spellClassification
                elseif spell.CastTime() <= 2000 then
                    spellClassification = "Quick" .. spellClassification
                end
            end,
            Summoned = function()
                spellClassification = "Nuke"
            end,
            Destroy = function()
                spellClassification = "DestroyNuke"
            end,
            Undead = function()
                spellClassification = "Nuke"
            end,
            Stun = function()
                spellClassification = "StunNuke"
                if Me.Class.ShortName() == "PAL" and spell.HateGenerated() > 0 then
                    spellClassification = "Stun"
                end
            end,
            Chromatic = function()
                spellClassification = "ChromaticNuke"
            end,
            Enthrall = function()
                spellClassification = "EnthrallNuke"
            end,
            Plant = function()
                spellClassification = "PlantNuke"
            end,
            Disease = function()
                spellClassification = "DiseaseNuke"
            end,
            Bane = function()
                spellClassification = "BaneNuke"
            end,
            Physical = function()
                spellClassification = "PhysicalNuke"
            end,
            Animal = function()
                spellClassification = "AnimalNuke"
            end
        },
        Transport = {
            Misc = function()
                if spell.Name() == "Gate" then
                    spellClassification = "Gate"
                    ignoreTargetType = true
                elseif spell.Name():endsWith("Succor") or spell.Name():endsWith("Evacuate") then
                    spellClassification = "Evac"
                    ignoreTargetType = true
                end
            end,
            Antonica = function()
                spellClassification = "Port"
            end,
            Odus = function()
                spellClassification = "Port"
            end,
            Faydwer = function()
                spellClassification = "Port"
            end,
            ["The Planes"] = function()
                spellClassification = "Port"
            end,
            Kunark = function()
                spellClassification = "Port"
            end,
            Luclin = function()
                spellClassification = "Port"
            end,
            ["Serpent's Spine"] = function()
                spellClassification = "Port"
            end,
            Velious = function()
                spellClassification = "Port"
            end,
            Taelosia = function()
                spellClassification = "Port"
            end,
            Discord = function()
                spellClassification = "Port"
            end
        },
        ["Utility Detrimental"] = {
            Slow = function()
                if spell.ResistType() ~= spellFinder.resistTypes.Magic then
                    spellClassification = spell.ResistType() .. "Slow"
                else
                    spellClassification = "Slow"
                end
            end,
            Disempowering = function()
                spellClassification = "Disempower"
            end,
            Root = function()
                spellClassification = "Root"
            end,
            ["Resist Debuffs"] = function()
                spellClassification = "ResistDebuff"
            end,
            Dispel = function()
                spellClassification = "Dispel"
            end,
            Enthrall = function()
                spellClassification = "Mez"
            end,
            Calm = function()
                spellClassification = "Paci"
            end,
            Fear = function()
                spellClassification = "Fear"
            end,
            Charm = function()
                spellClassification = "Charm"
            end,
            ["Mana Drain"] = function()
                spellClassification = "ManaDrain"
            end,
            Snare = function()
                spellClassification = "Snare"
            end,
            Blind = function()
                spellClassification = "Blind"
            end,
            Jolt = function()
                spellClassification = spellFinder.FindDotType(spell.StackingGroup())
                if not spellClassification then
                    spellClassification = "Jolt"
                end
            end,
            ["Memory Blur"] = function()
                spellClassification = "MemBlur"
            end,
            Undead = function()
                if spell.Name() == "Shackle of Spirit" or spell.Name() == "Shackle of Bone" then
                    spellClassification = "Slow"
                end
            end,
            Movement = function()
            end,
            ["Combat Innates"] = function()
            end
        },
        ["Create Item"] = {
            ["Summon Food/Water"] = function()
                spellClassification = "SummonFoodWater"
            end,
            ["Summon Utility"] = function()
                spellClassification = "SummonUtility"
            end,
            Misc = function()
                spellClassification = "SummonMana"
            end,
            ["Imbue Gem"] = function()
                spellClassification = "ImbueGem"
            end,
            ["Summon Weapon"] = function()
                spellClassification = "SummonWeapon"
            end,
            ["Enchant Metal"] = function()
                spellClassification = "EnchantMetal"
            end,
            Mana = function()
                spellClassification = "CreateMana"
            end,
            ["Summon Focus"] = function()
                spellClassification = "SummonFocus"
            end,
            ["Summon Armor"] = function()
                spellClassification = "SummonArmor"
            end
        },
        ["Utility Beneficial"] = {
            Movement = function()
                if spell.Name() == "Spirit of Bih`Li" or spell.Name() == "Pack Spirit" or spell.Name() ==
                    "Spirit of Wolf" or spell.Name() == "Spirit of Eagle" or spell.Name() == "Flight of Eagles" or
                    spell.Name() == "Selo's Accelerating Chorus" or spell.Name() == "Selo's Accelerando" then
                    spellClassification = "Sow"
                end
            end,
            Levitate = function()
                spellClassification = "Levitate"
            end,
            Misc = function()
                if Me.Class.ShortName() == "CLR" then
                    local spellName = spell.Name()
                    if spellName:endsWith("Retort") then
                        spellClassification = "ReverseHealProc"
                    elseif spellName:startsWith("Divine") or spellName == "Death Pact" then
                        spellClassification = "DivineIntervention"
                    end
                end
                if Me.Class.ShortName() == "SHM" or Me.Class.ShortName() == "DRU" then
                    if spell.Name():startsWith("Preincarnation") or spell.Name():startsWith("Second Life") then
                        spellClassification = "DivineIntervention"
                    end
                end
                if spell.Name() == "Tiny Terror" or spell.Name() == "Shrink" then
                    spellClassification = "Shrink"
                end
                if Me.Class.ShortName() == "MAG" then
                    spellClassification = spellFinder.FindDotType(spell.StackingGroup())
                end
                if Me.Class.NecromancerType() then
                    if spell.Attrib(1)() == 74 then
                        ignoreTargetType = true
                        spellClassification = "FeignDeath"
                    end
                end
                if Me.Class.ShortName() == "BST" then
                    if spell.Name():endsWith("Collaboration") then
                        spellClassification = "KillProc"
                    end
                end
                if Me.Class.ShortName() == "SHD" then
                    if spell.Name() == "Shroud of Undeath" then
                        spellClassification = "TapProc"
                    end
                end
                if Me.Class.ShortName() == "BRD" then
                    if spell.Name() == "Amplification" then
                        spellClassification = "Amplification"
                    end

                end
            end,
            Conversions = function()
                if Me.Class.ShortName() == "SHM" then
                    ignoreTargetType = true
                    spellClassification = "Canni"
                elseif Me.Class.NecromancerType() then
                    ignoreTargetType = true
                    spellClassification = "Lich"
                end
            end,
            Haste = function()
                spellClassification = "Haste"
            end,
            Invisibility = function()
                if spell.Attrib(1)() == 314 or spell.Attrib(1)() == 12 then
                    spellClassification = "Invisibility"
                elseif spell.Attrib(1)() == 315 or spell.Attrib(1)() == 28 then
                    spellClassification = "UndeadInvisibility"
                end
            end,
            ["Combat Innates"] = function()
                if Me.Class.ShortName() == "CLR" then
                    if spell.Name():startsWith("Vow") then
                        spellClassification = "VowProc"
                    elseif spell.Name():startsWith("Ward") then
                        spellClassification = "WardProc"
                    else
                        spellClassification = "HealProc"
                    end
                elseif Me.Class.ShortName() == "SHM" then
                    if spell.NumEffects() == 3 then
                        spellClassification = "DefensiveProc"
                    elseif spell.NumEffects() == 5 then
                        spellClassification = "OffensiveProc"
                    elseif spell.NumEffects() == 10 or spell.NumEffects() == 8 then
                        spellClassification = "SpellProc"
                    end
                elseif Me.Class.ShortName() == "ENC" then
                    spellClassification = spellFinder.FindDotType(spell.StackingGroup())
                    if not spellClassification then
                        spellClassification = "MezDefensiveProc"
                    end
                elseif Me.Class.ShortName() == "MAG" or Me.Class.ShortName() == "NEC" or Me.Class.ShortName() == "DRU" then
                    spellClassification = "DefensiveProc"
                elseif Me.Class.ShortName() == "SHD" then
                    if spell.Name():startsWith("Shroud of") or spell.Name() == "Vampiric Embrace" or spell.Name() ==
                        "Scream of Death" or spell.Name() == "Black Shroud" then
                        spellClassification = "TapProc"
                    elseif spell.Name():endsWith("Horror") or spell.Name() == "Mental Corruption" then
                        spellClassification = "ManaTapProc"
                    elseif spell.Name():endsWith("Skin") then
                        spellClassification = "DefensiveProc"
                    end
                elseif Me.Class.ShortName() == "RNG" then
                    if spell.Name() == "Consumed by the Hunt" then
                        spellClassification = "KillProc"
                    else
                        spellClassification = "OffensiveProc"
                    end
                elseif Me.Class.ShortName() == "PAL" then
                    if spell.Name():endsWith("Nife") or spell.Name() == "Silvered Fury" then
                        spellClassification = "UndeadProc"
                    elseif spell.Name():find("Tunare") then
                        spellClassification = "DefensiveProc"
                    elseif spell.Name():startsWith("Remorse") then
                        spellClassification = "KillProc"
                    else
                        spellClassification = "OffensiveProc"
                    end
                end
            end,
            ["Illusion: Other"] = function()
                if Me.Class.ShortName() == "ENC" then
                    spellClassification = "Illusion"
                end
            end,
            Vision = function()
                if Me.Class.ShortName() == "RNG" and spell.Name():endsWith("Eye") then
                    spellClassification = "ArrowCrit"
                end
            end,
            ["Damage Shield"] = function()
                if Me.Class.ShortName() == "CLR" then
                    spellClassification = "Mark"
                elseif Me.Class.ShortName() == "SHM" then
                    spellClassification = "NegateDamageShield"
                else
                    spellClassification = "DamageShield"
                end
            end,
            Heals = function()
                if Me.Class.ShortName() == "SHM" then
                    spellClassification = "SlowHeal"
                end
            end,
            Shadowstep = function()
            end,
            Alliance = function()
                spellClassification = "Alliance"
            end,
            ["Spell Focus"] = function()
                if spell.Attrib(1)() == 127 then
                    spellClassification = "SpellHaste"
                end
            end,
            Rune = function()
                spellClassification = "Rune"
            end,
            Invulnerability = function()
                spellClassification = "DA"
            end,
            Reflection = function()
                spellClassification = "Reflection"
            end,
            ["Haste/Spell Focus"] = function()
            end,
            Animal = function()
            end,
            ["Melee Guard"] = function()
                spellClassification = 'MeleeGuard'
            end,
            Summoned = function()
            end,
            Visages = function()
                if Me.Class.ShortName() == "ENC" then
                    if spell.Base(1)() < 0 then
                        spellClassification = "CalmVisage"
                    elseif spell.Base(1)() > 0 then
                        spellClassification = "AggroVisage"
                    end
                elseif Me.Class.ShortName() == "SHD" then
                    spellClassification = "AggroVisage"
                end
            end,
            ["Illusion: Adventurer"] = function()
                if Me.Class.ShortName() == "ENC" then
                    spellClassification = "Illusion"
                end
            end,
            ["Spell Guard"] = function()
                spellClassification = "SpellGuard"
            end,
            Twincast = function()
                spellClassification = "Twincast"
            end,
            Defensive = function()
            end,
            Spellshield = function()
            end
        },
        ["Damage Over Time"] = {
            Poison = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                elseif Me.Class.NecromancerType() then
                    spellClassification = "VenomDot"
                else
                    spellClassification = "PoisonDot"
                end
            end,
            Disease = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                elseif Me.Class.NecromancerType() then
                    spellClassification = "RotDot"
                else
                    spellClassification = "DiseaseDot"
                end
            end,
            Magic = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                else
                    spellClassification = "MagicDot"
                end
            end,
            Fire = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                elseif Me.Class.NecromancerType() then
                    spellClassification = "PyreDot"
                else
                    spellClassification = "FireDot"
                end
            end,
            Cold = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                else
                    spellClassification = "ColdDot"
                end
            end,
            Undead = function()
                spellClassification = "Dot"
            end,
            Snare = function()
                spellClassification = "SnareDot"
            end,
            Corruption = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                elseif Me.Class.ShortName() == "NEC" then
                    spellClassification = "CorruptionDot"
                end
            end,
            Plant = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                end
            end,
            ["Mana Drain"] = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                else
                    spellClassification = "ManaDot"
                end
            end,
            Misc = function()
                local result = spellFinder.FindDotType(spell.StackingGroup())
                if result then
                    spellClassification = result .. "Dot"
                end
            end
        },
        Regen = {
            Health = function()
                if Me.Class.ShortName() == "MAG" then
                    spellClassification = "PhantomLeather"
                else
                    spellClassification = "HPRegen"
                end
            end,
            Mana = function()
                if Me.Class.ShortName() == "ENC" or Me.Class.ShortName() == "BRD" then
                    spellClassification = "ManaRegen"
                end
            end,
            ["Health/Mana"] = function()
                if Me.Class.ShortName() == "MAG" then
                    spellClassification = "PhantomLeather"
                elseif Me.Class.ShortName() == "BST" or Me.Class.ShortName() == "BRD" then
                    spellClassification = "HPManaRegen"
                end
            end
        },
        Pet = {
            ["Sum: Warder"] = function()
                spellClassification = "Pet"
                ignoreTargetType = true
            end,
            Misc = function()
                if spell.Name() == "Tiny Companion" then
                    spellClassification = "Shrink"
                elseif spell.Name() == "Reclaim Energy" then
                    spellClassification = "ReclaimEnergy"
                elseif spell.Name() == "Summon Companion" then
                    spellClassification = "SummonCompanion"
                elseif spell.Name():startsWith("Monster Summoning") then
                    spellClassification = "MonsterSummon"
                end
            end,
            ["Pet Haste"] = function()
                spellClassification = "Haste"
            end,
            ["Sum: Animation"] = function()
                ignoreTargetType = true
                if Me.Class.ShortName() == "CLR" or Me.Class.ShortName() == "WIZ" then
                    spellClassification = "TargetPet"
                elseif Me.Class.ShortName() == "ENC" then
                    spellClassification = "Pet"
                end
            end,
            ["Sum: Earth"] = function()
                ignoreTargetType = true
                spellClassification = "EarthPet"
            end,
            ["Sum: Water"] = function()
                ignoreTargetType = true
                spellClassification = "WaterPet"
            end,
            ["Sum: Fire"] = function()
                ignoreTargetType = true
                spellClassification = "FirePet"
            end,
            ["Sum: Air"] = function()
                ignoreTargetType = true
                spellClassification = "AirPet"
            end,
            ["Pet Misc Buffs"] = function()
                if spell.Name() == "Expedience" or spell.Name() == "Velocity" then
                    spellClassification = "SoW"
                elseif spell.Name() == "Valiant Companion" then
                    spellClassification = "Fearless"
                elseif spell.Name():startsWith("Iceflame") then
                    spellClassification = "Proc"
                elseif spell.Name() == "Energize Ally" or spell.Name() == "Necrotize Ally" then
                    spellClassification = "Explode"
                elseif Me.Class.ShortName() == "BST" then
                    if spell.Name():endsWith("Jaws") then
                        spellClassification = "SlowProc"
                    elseif spell.Name():endsWith("Protection") then
                        spellClassification = "TankBuff"
                    elseif spell.Name():endsWith("Aggression") then
                        spellClassification = "DPSBuff"
                    elseif spell.Name():startsWith("Growl of the") then
                        ignoreTargetType = true
                        spellClassification = "PetAvatar"
                    elseif spell.Name():endsWith("Warder") or spell.Name() == "Friendly Pet" then
                        spellClassification = "HealProc"
                    else
                        spellClassification = "Proc"
                    end
                end
            end,
            Heals = function()
                spellClassification = "Heal"
            end,
            ["Sum: Swarm"] = function()
                ignoreTargetType = true
                if Me.Class.ShortName() == "MAG" then
                    if spell.Name() == "Dyzil's Deafening Decoy" then
                        spellClassification = "DecoyPet"
                    end
                end
                if not spellClassification then
                    spellClassification = "SwarmPet"
                end
            end,
            Block = function()
                if spell.Name() == "Kindle" then
                else
                    spellClassification = "Block"
                end
            end,
            Conversions = function()
                spellClassification = "Canni"
            end,
            Delayed = function()
                spellClassification = "DelayedHeal"
            end,
            ["Combat Innates"] = function()
                if Me.Class.ShortName() == "MAG" then
                    spellClassification = "DefensiveProc"
                end
            end,
            ["Mana Flow"] = function()
                spellClassification = "Explode"
            end,
            ["Sum: Undead"] = function()
                spellClassification = "Pet"
            end,
            ["Illusion: Other"] = function()
            end,
            ["Resist Buff"] = function()
                spellClassification = "SpellShield"
            end,
            Offensive = function()
            end,
            ["Sum: Familiar"] = function()
                spellClassification = "Familiar"
            end
        },
        Traps = {
            ["Resist Debuffs"] = function()
                spellClassification = "ResistDebuffTrap"
                ignoreTargetType = true
            end,
            ["Damage Over Time"] = function()
                ignoreTargetType = true
                spellClassification = "DotTrap"
            end,
            Fear = function()
                ignoreTargetType = true
                spellClassification = "FearTrap"
            end,
            ["Direct Damage"] = function()
            end
        },
        Auras = {
            ["Haste/Spell Focus"] = function()
                ignoreTargetType = true
            end,
            Regen = function()
                ignoreTargetType = true
                spellClassification = "RegenAura"
            end,
            Heals = function()
                ignoreTargetType = true
                spellClassification = "HealAura"
            end,
            ["Melee Guard"] = function()
                ignoreTargetType = true
                spellClassification = "MeleeGuardAura"
            end,
            ["HP Buffs"] = function()
                ignoreTargetType = true
                spellClassification = "HPAura"
            end,
            Mana = function()
                ignoreTargetType = true
                if spell.Name():endsWith("Acumen") then
                    spellClassification = "ManaAura"
                else
                    spellClassification = "ManaRegenAura"
                end
            end,
            Learning = function()
                ignoreTargetType = true
                spellClassification = "ExpAura"
            end,
            Rune = function()
                ignoreTargetType = true
                spellClassification = "RuneAura"
            end,
            Visages = function()
                ignoreTargetType = true
                if spell.Name() == "Aura of Endless Glamour" then
                    spellClassification = "CalmingAura"
                else
                    spellClassification = "AggroAura"
                end
            end,
            ["Combat Innates"] = function()
                ignoreTargetType = true
                if Me.Class.ShortName() == "ENC" then
                    spellClassification = "ManastormAura"
                end
            end,
            Charm = function()
                ignoreTargetType = true
                spellClassification = "CharmAura"
            end,
            Twincast = function()
                ignoreTargetType = true
                spellClassification = "TwinCastAura"
            end,
            Disempowering = function()
                ignoreTargetType = true
                if Me.Class.ShortName() == "ENC" then
                    spellClassification = "ResistDebuffAura"
                end
            end,
            Calm = function()
                ignoreTargetType = true
                spellClassification = "CalmAura"
            end,
            ["Damage Over Time"] = function()
                ignoreTargetType = true
                spellClassification = "DotAura"
            end,
            ["Health/Mana"] = function()
                ignoreTargetType = true
            end
        },
        Objects = {
            ["Disarm Traps"] = function()
                spellClassification = "DisarmTrap"
            end,
            Picklock = function()
                spellClassification = "PickLock"
            end,
            ["Sense Trap"] = function()
                spellClassification = "SenseTrap"
            end
        },
        ["Pet Misc Buffs"] = {
            Auras = function()
                ignoreTargetType = true
                spellClassification = "PetAura"
            end
        },
        Taps = {
            Health = function()
                if spell.TargetType == "LifeTap" then
                    ignoreTargetType = true
                    spellClassification = "MaxHealthTap"
                else
                    spellClassification = "Lifetap"
                end
            end,
            ["Power Tap"] = function()
                -- Taps are wierd, while they have attribs we could key off of, it's typically one or the other until SKs get the agony/hate line
                if spell.Name() == "Siphon Strength" then
                    spellClassification = "StrTap"
                elseif spell.Name() == "Degeneration" then
                    spellClassification = "StaTap"
                elseif spell.Name() == "Succussion of Shadows" or spell.Name():endsWith("of Pain") or
                    spell.Name():endsWith("of Agony") then
                    spellClassification = "ACTap"
                elseif spell.Name() == "Crippling Claudication" or spell.Name():endsWith("of Hate") or spell.Name() ==
                    "Despair" then
                    spellClassification = "AtkTap"
                end
            end,
            ["Duration Tap"] = function()
                spellClassification = "DurationTap"
            end,
            ["Create Item"] = function()
                spellClassification = "ShardTap"
            end,
            ["Health/Mana"] = function()
                spellClassification = "ManaLifeTap"
            end
        },
        Invulnerability = {
            Fear = function()
            end
        },
        ["Spell Focus"] = {
            Mana = function()
            end
        }
    }
    if spell.Category() and spell.Subcategory() then
        spellTable[spell.Category()][spell.Subcategory()]()
        if spellClassification and not ignoreTargetType then
            spellClassification = spellFinder.__prependTargetType(spell, spellClassification)
        end
    end
    return spellClassification
end

return spellFinder
