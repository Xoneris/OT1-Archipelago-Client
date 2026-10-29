require "archipelago"
-- local AP = require "lua-apclientpp"

local UEHelpers = require("UEHelpers")

local allowHook = false
local Dialog = nil
local DialogText = nil
local Chest = nil
local CurrentLevelID = nil
local CurrentLevel = nil
-- local ItemFunction = nil
local testSucces = {}


print("[HelloWorldMod] Hello from Octopath!")
print(_VERSION)

RegisterConsoleCommandHandler("GiveItem", function(FullCommand, Parameters)

    -- print("Full Command: " .. tostring(FullCommand))
    -- print("Parameters: " .. tostring(Parameters))
    -- print(tostring(Parameters[1]))
    ReceiveItem(Parameters[1])
    OpenNotifiction("You just received " .. Parameters[1] .. " via a console command!")

    return true
end)

RegisterConsoleCommandHandler("Connect", function(FullCommand, UserInput)

    local Server = UserInput[1] or ""
    local Slot = UserInput[2] or ""
    local Password = UserInput[3] or ""

    print("Server: " .. tostring(UserInput[1]))
    print("Slot: " .. tostring(UserInput[2]))
    print("Password: " .. tostring(UserInput[3]))

    ConnectToAP(Server,Slot,Password)

    return true
end)

RegisterKeyBind(Key.F10, function()

    -- local SaveGame1 = StaticFindObject("/Game/System/BP/SaveLoad/KSSaveDataManagerBP.KSSaveDataManagerBP_C")
    local SaveGame1 = StaticFindObject("/Game/System/BP/SaveLoad/KSSaveGameBP.KSSaveGameBP_C")
    -- local SaveGame2 = FindFirstOf("KSSaveDataManagerBP")
    local SaveGame2 = SaveGame1:GetCDO()

    local Function = StaticFindObject(
        -- "/Game/System/BP/SaveLoad/KSSaveDataManagerBP.KSSaveDataManagerBP_C:JoinCharacterToParty"
        "/Game/System/BP/SaveLoad/KSSaveGameBP.KSSaveGameBP_C:JoinCharacterToParty"
    )

    local SaveGame3 = FindFirstOf("KSSaveGameBP_C")

    local Result = {}
    local IsAddMainMember = {}

    -- DiagnosticOnElement(SaveGame1)
    -- DiagnosticOnElement(SaveGame2)
    -- DiagnosticOnElement(SaveGame3)
    -- DiagnosticOnElement(Function)

    -- void JoinCharacterToParty(EPlayableCharacterID CharacterID, bool& Result, bool& IsAddMainMember);
    -- void SetCharacterHP(int32 CharacterID, int32 HP);
    SaveGame3:JoinCharacterToParty(1,Result,IsAddMainMember)
    SaveGame3:SetCharacterHP(1,999)
    SaveGame3:SetCharacterMP(1,999)
    SaveGame3:SetCharacterMissionProcessCnt(1,110)

end)

RegisterKeyBind(Key.F9, function()
    local item = "ITM_139"
    ReceiveItem(item)
    OpenNotifiction("You just received " .. item .. "!")

end)

RegisterKeyBind(Key.K, function()
    local pc = UEHelpers:GetPlayerController() -- required for getting world context
    local __WorldContext = pc:GetWorld() -- required for some functions.

    local Notification = StaticFindObject("/Game/Library/LibUIUtil.LibUIUtil_C")
    local NotificationCDO = Notification:GetCDO()

    NotificationCDO:CommonNotification(
        FText("Cool test Text!"),
        __WorldContext
    )

end)

RegisterKeyBind(Key.F7, function()
    local ItemName = ConvertItemLabelToItemName("ITM_139")
    OpenNotifiction("Received " .. tostring(ItemName))
end)

function DiagnosticOnElement(Element)

    print("Object: " .. tostring(Element))
    print("Type: " .. tostring(type(Element)))

    if Element and Element:IsValid() then
        print("Full name: " .. tostring(Element:GetFullName()))
        print("Class: " .. tostring(Element:GetClass():GetFullName()))
        -- print("Function member: " .. tostring(Element.JoinCharacterToParty))
    else 
        print("Not valid")
    end
end

function GetWorldContext()
    local pc = UEHelpers:GetPlayerController() -- required for getting world context
    local __WorldContext = pc:GetWorld() -- required for some functions.
    return __WorldContext
end

function GetItemFunctions()
    local ItemFunctions = StaticFindObject("/Game/Item/BP/ItemFunction.ItemFunction_C")
    local ItemFunctionsCDO = ItemFunctions:GetCDO()
    return ItemFunctionsCDO
end 

function GetTextStatics()
    local TextStatics = StaticFindObject("/Script/Octopath_Traveler.KSTextStatics")
    local TextStaticsCDO = TextStatics:GetCDO()
    return TextStaticsCDO
end

function GetLevelFunctions()
    local LevelFunctions = StaticFindObject("/Game/Level/BP/LevelFunction.LevelFunction_C")
    local LevelFunctionsCDO = LevelFunctions:GetCDO()
    return LevelFunctionsCDO
end

function GetLibUIUtilFunctions()
    local LibUIUtilFunctions = StaticFindObject("/Game/Library/LibUIUtil.LibUIUtil_C")
    local LibUIUtilFunctionsCDO = LibUIUtilFunctions:GetCDO()
    return LibUIUtilFunctionsCDO
end

function GetSaveGame()
    local SaveGame = FindFirstOf("KSSaveGameBP_C")
    return SaveGame
end

function ConvertItemLabelToItemName(ItemLabel)

    local pc = UEHelpers:GetPlayerController() -- required for getting world context
    local __WorldContext = pc:GetWorld() -- required for some functions.

    local ItemFunction = StaticFindObject("/Game/Item/BP/ItemFunction.ItemFunction_C")
    local ItemFunctionCDO = ItemFunction:GetCDO()
    local ItemData = {}

    ItemFunctionCDO:GetItemData(
        FName(ItemLabel),
        __WorldContext,
        ItemData
    )

    local TextStatics = StaticFindObject("/Script/Octopath_Traveler.KSTextStatics")
    local TextStaticsCDO = TextStatics:GetCDO()

    local ItemNameID = ItemData.ItemNameID_118_78CF4DCD438E1C10ADEE2D951C83C0BE:ToString()
    local OutText2 = {}

    -- void GetGameText(FName Label, FText& OutText);
    TextStaticsCDO:GetGameText(FName(ItemNameID), OutText2)

    return OutText2.OutText:ToString()
    
end

function OpenNotifiction(Message)

    local WorldContext = GetWorldContext()

    -- local GameStatics = StaticFindObject("/Script/Octopath_Traveler.KSGameStatics")
    -- local GameStaticsCDO = GameStatics:GetCDO()
    -- local isMainMenuOpen = GameStaticsCDO:IsMainMenuOpen(__WorldContext)

    -- local Notification = StaticFindObject("/Game/Library/LibUIUtil.LibUIUtil_C")
    -- local NotificationCDO = Notification:GetCDO()
    local LibUIUtilFunctions = GetLibUIUtilFunctions()

    -- if isMainMenuOpen then 
    --     ExecuteWithDelay(3000, OpenNotifiction(Message))
    -- else 
    --     NotificationCDO:CommonNotification(
    --     FText(Message),
    --     __WorldContext
    -- )
    -- end
    LibUIUtilFunctions:CommonNotification(
        FText(Message),
        WorldContext
    )

end 

function ReceiveItem(ItemLabel,PlayerName)

    print("Debug - Item Label received: " .. tostring(ItemLabel))

    local WorldContext = GetWorldContext()
    local ItemFunctions = GetItemFunctions()

    if ItemLabel ~= nil then 
        -- FName itemId, int32 AddNum, class UObject* __WorldContext, bool& Success
        ItemFunctions:AddBackpackItem(
            FName(ItemLabel),
            1,
            WorldContext,
            {true}
        )
    end
end

function GetCurrentLevel()

    local Manager = FindFirstOf("LevelManager")

    if Manager and Manager:IsValid() then
        print("Instance: " .. tostring(Manager:GetFullName()))
        print("Class: " .. tostring(Manager:GetClass():GetFullName()))

        local Name = Manager:GetCurrentLevelName()
        print("Returned type: " .. tostring(type(Name)))
        print("Returned value: " .. tostring(Name:ToString()))
        return Name:ToString()
    else
        print("LevelManager instance not found")
        return nil
    end
end 

function listen_()
    
    

    if allowHook == false then
        ExecuteWithDelay(10000, listen_)
    else

        RegisterHook("/Game/Object/BP/TreasureBoxBP.TreasureBoxBP_C:Open", function(Context)

            Chest = Context:get()
            print("Chest Index " .. tostring(Chest.TreasureIndex) .. " in map " .. CurrentLevel .. " was opened!")

            -- To Do:
            -- Here is probably where I implement sending checks to the server when you actually open a chest
            -- containing a AP Item.
            -- Also somewhere in here I need to get the currentLevelID, since treasure chest index are locally 
            -- bound to the area.
            SendLocationCheck(CurrentLevel,Chest.TreasureIndex)

        end)

        RegisterHook("/Game/Item/BP/ItemFunction.ItemFunction_C:AddBackpackItem", function(Context,ItemID)

            print("A Item was added to your Backpack!")

        end)

        RegisterHook("/Game/UI/Dialog/UICommonDialogBP.UICommonDialogBP_C:OpenDialog", function(Context,DialogParam)

            print("A dialog has been opened!")

        end)

                
        -- RegisterHook("/Game/Level/BP/LevelFunction.LevelFunction_C:RequestMapChange", function(Context)
        RegisterHook("/Script/Octopath_Traveler.LevelManager:FinishFadeIn", function(Context)

            print("level changed!")
            CurrentLevel = GetCurrentLevel()

            local AllChestsInCurrentLevel = FindAllOf("TreasureBoxBP_C")

            for index, Chest in ipairs(AllChestsInCurrentLevel) do

                print("chest count: " .. tostring(index))

                -- Change Chest that have money in Vanilla to instead have an Item with the count of 1
                if Chest.ObjectData.IsMoney == true then
                    -- -@diagnostic disable-next-line: inject-field
                    Chest.ObjectData.IsMoney = false
                    Chest.ObjectData.HaveItemCnt = 1
                end

                -- Replace each content of a Chest instead with AP_ITM_(index of the for loop)
                local APItemLabel = "AP_ITM_" .. index
                Chest.ObjectData.HaveItemLabel = FName(APItemLabel)

                -- Replace the text of the placeholder AP Item descriptions in the database
                -- Override it with the text of the actual multiworld Item in that chest
                -- (Note: I think this will so far only work if you're playing on the english version, needs further testing)
                local TextDB = StaticFindObject("/Game/GameText/Database/GameTextEN.GameTextEN")

                -- ### Currently disabled below code because TX_NA_AP_ITM_ does not exist yet
                if (TextDB:FindRow("TX_NA_" .. APItemLabel) and TextDB:FindRow("TX_NA_" .. APItemLabel):IsValid()) then
                    -- TextDB:FindRow("TX_NA_" .. APItemLabel).Text = FText("Overriding Text of AP Item 1!")
                    -- print("success!")
                    local test = TextDB:FindRow("TX_NA_" .. APItemLabel).Text
                    print("Item Label: " .. tostring(test:ToString()))
                else 
                    print("Failed to find Text for Item label: TX_NA_" .. APItemLabel)
                end

            end

        end)

        -- void SubMissionEnd(FName SubMissionLabel, int32 ClearIndex, class UObject* __WorldContext);
        RegisterHook("/Game/Mission/BP/MissionFunctionBP.MissionFunctionBP_C:SubMissionEnd", function() 
            print("Submission finished!")
        end)

        -- void SetCharacterMissionProcessCnt(int32 CharacterID, int32 MainMissionProgressCnt);
        RegisterHook("/Game/System/BP/SaveLoad/KSSaveGameBP.KSSaveGameBP_C:SetCharacterMissionProcessCnt", function(Context, CharacterID, MainMissionProgressCnt)
            local CharID = CharacterID:get()
            local MainMissionProgress = MainMissionProgressCnt:get()
            print("Character " .. CharID .. "progressed Main Mission to " .. MainMissionProgress .. "!")
        end)

        -- void JoinCharacterToParty(EPlayableCharacterID CharacterID, bool& Result, bool& IsAddMainMember);
        RegisterHook("/Game/System/BP/SaveLoad/KSSaveGameBP.KSSaveGameBP_C:JoinCharacterToParty", function(Context, CharacterID)
            local CharID = CharacterID:get()
            print("Character " .. CharID .. " was added to the party!")
        end)

        -- RegisterHook("/Game/Library/LibUIUtil.LibUIUtil_C:LevelChangeNotificationStart", function(Context,LevelID)
        -- RegisterHook("/Script/Octopath_Traveler.LevelManager:SetCurrentLevelID", function(Context,LevelID)
        -- -- RegisterHook("/Script/Octopath_Traveler.LevelManager:GetCurrentLevelDataID", function(Context)

        --     CurrentLevelID = LevelID:get()
        --     -- CurrentLevelID = Context:get()
        --     print("Current Map ID: " .. tostring(CurrentLevelID)) 

        --     local __WorldContext = GetWorldContext()
        --     local LevelFunctions = GetLevelFunctions()

        --     -- void GetMapAndRegionNameByLevelID(int32 LevelID, int32 Selection, class UObject* __WorldContext, FText& RegionName, FText& MapName);

        --     local AllChestsInCurrentLevel = FindAllOf("TreasureBoxBP_C")

        --     for _, Chest in ipairs(AllChestsInCurrentLevel) do
        --         -- if ScoutedLocations[Chest.ObjectData.ID] ~= nil and Chest.ObjectData.HaveItemLabel:ToString() ~= "APItem".._ and Chest.IsOpenFlag == false then
        --             if Chest.ObjectData.IsMoney == true then
        --             -- -@diagnostic disable-next-line: inject-field
        --                 -- Chest.ObjectData.IsMoney = false
        --                 print("Money: " .. tostring(Chest.ObjectData.HaveItemCnt))
        --                 -- Chest.ObjectData.HaveItemCnt = 42069

        --             else 
        --                 print("Item: " .. tostring(Chest.ObjectData.HaveItemLabel:ToString()))
        --                 -- print("chest text: " .. tostring(Chest.TempDialog.NowParam.DetailText:ToString()))
        --             end
                    
        --             -- local ScoutedLocationV = ScoutedLocations[Chest.ObjectData.ID]
        --             -- print(ScoutedLocationV["ItemName"].." for "..ScoutedLocationV["PlayerName"])
                    
        --             -- Chest.ObjectData.HaveItemLabel = FName("AP_ITM_".._)
        --             -- TextDB:FindRow("APItemText".._).Text = FText(ScoutedLocationV["ItemName"].." for "..ScoutedLocationV["PlayerName"])
                    
        --             -- if Chest.ObjectData.HaveItemLabel:ToString() == "ITM_037" then

        --             --     print("yes is shadow Soulstone")
        --             --     -- TX_NA_ITM_037

        --             --     local __WorldContext = GetWorldContext()
        --             --     local ItemFunction = GetItemFunctions()
        --             --     local TextStatics = GetTextStatics()
        --             --     local ItemData = {}
        --             --     local ItemText = {}

        --             --     ItemFunction:GetItemData(
        --             --         FName("ITM_037"),
        --             --         __WorldContext,
        --             --         ItemData
        --             --     )

        --             --     local ItemNameID = ItemData.ItemNameID_118_78CF4DCD438E1C10ADEE2D951C83C0BE
        --             --     print ("Name ID: " .. ItemNameID:ToString())
                        
        --             --     -- void GetGameText(FName Label, FText& OutText);
        --             --     TextStatics:GetGameText(ItemNameID, ItemText)

        --             --     local TextDB = StaticFindObject("/Game/GameText/Database/GameTextEN.GameTextEN")

        --             --     local test = TextDB:FindRow("TX_NA_ITM_037").Text
        --             --     print("Text: " .. tostring(test:ToString()))

        --             --     TextDB:FindRow("TX_NA_ITM_037").Text = FText("VeryCoolApItem for VeryCoolAPPlayer")

        --             --     -- local test1 = TextDB:FindRow("ITM_037").Text
        --             --     -- local test2 = TextDB:FindRow("TX_NA_ITM_037").Text
        --             --     -- print("test1: " .. tostring(test1))
        --             --     -- print("test2: " .. tostring(test2))

        --             --     -- local test = TextDB:DoesDataTableRowExist()

        --             --     -- print("TextDB: " .. tostring(TextDB))
        --             --     -- print("TextDB struct: " .. tostring(TextDB:GetFullName()))
        --             --     -- print("TextDB struct type: " .. tostring(TextDB:GetClass():GetFullName()))
                        
        --             --     -- if TextDB and TextDB:IsValid() then
        --             --     --     print("Object: " .. TextDB:GetFullName())
        --             --     --     print("Class: " .. TextDB:GetClass():GetFullName())
        --             --     -- else
        --             --     --     print("TextDB not found or invalid!")
        --             --     -- end

        --             --     -- local DataTableClass = TextDB:GetClass()
        --             --     -- print("GetRowNames: " .. tostring(DataTableClass.GetRowNames))
        --             --     -- print("FindRow: " .. tostring(DataTableClass.FindRow))
        --             --     -- print("RowStruct: " .. tostring(TextDB.RowStruct))
        --             --     -- print("RowMap: " .. tostring(TextDB.RowMap))

        --             --     -- local RowStruct = TextDB.RowStruct
        --             --     -- print("Row struct: " .. tostring(RowStruct:GetFullName()))
        --             --     -- print("Row struct type: " .. tostring(RowStruct:GetClass():GetFullName()))
        --             --     -- print("FindRow: " .. tostring(TextDB.FindRow))
        --             --     -- print("GetRowNames: " .. tostring(TextDB.GetRowNames))

        --             --     -- print(tostring(TextDB:__index(FName(ItemNameID))))

        --             -- end

        --         -- end
        --     end

        --     -- local LevelId = Context:get()
        --     -- print("hi test!") 
        --     -- print(tostring(LevelID))
        -- end)

        -- void GetItemData(FName itemId, class UObject* __WorldContext, FItemData& ItemData);
        -- RegisterHook("/Game/Item/BP/ItemFunction.ItemFunction_C:GetItemData", function(Context,ItemID)
        --     local CurrentItemID = ItemID:get()
        --     print("Item ID: " .. tostring(CurrentItemID:ToString()))
        -- end)
        
    end
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(Context, NewPawn)
    allowHook = true

end)

listen_()