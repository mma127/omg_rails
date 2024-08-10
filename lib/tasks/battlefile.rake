require 'zlib'
require 'digest'

task battlefile: :environment do

  battleid = 46
  file_contents = '
MinTerritoryCheck = true
MaxPopcap = 40
StartPopCap = 25
PopCapIncrementation = 1
BattleAttacker = 0
TerritoryEndTime = 170
TerritoryCheckIncreaseTime = 60 * 5
BattleID = 679
BattleMode = "MCP"

SpawnArtyNeeded = true
WinningCueNeeded = true
TerritoryCheckWinNeeded = true

function Setup_PlayerUnits(player)
   print("Setup_PlayerUnits")
   local pid = Player_GetID(player) - 999
   if Player[pid].Name == "Razor" then
      Player[pid].Race = 1
      Player[pid].Doctrine = OMGUPG.ALLY.INFANTRYDOC
      Player[pid].Arrival = 5
      Player[pid].Para_Extra_Time = 15
      Player[pid].Glider_Extra_Time = 15
      Player[pid].Report_Delay = 5
      Player[pid].CompanyId = 934
      Player[pid].GliderSpawning = true
      Player[pid].Abilities = {
      }
      Player[pid].Buildings = {
      }
      Player[pid].Platoons = {
         {
            PlatoonID = "1x1x1",
            Pop = 17,
            CallInTimeModifier = 1,
            NotAvailUntil = 0,
            Squadnumber = 2,
            Glider = false,
            ParaDrop = false,
            Infiltrate = false,
            HalfTrack = false,
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22083"),
               BP = OMGSBPS.ALLY.RIFLEMEN,
               exp = 0.0000,
               SquadPop = 5,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22084"),
               BP = OMGSBPS.ALLY.SHERMAN,
               exp = 0.0000,
               SquadPop = 12,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
         },
         {
            PlatoonID = "1x1x8",
            Pop = 12,
            CallInTimeModifier = 1,
            NotAvailUntil = 0,
            Squadnumber = 2,
            Glider = false,
            ParaDrop = false,
            Infiltrate = false,
            HalfTrack = false,
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22135"),
               BP = OMGSBPS.ALLY.QUAD,
               exp = 0.0000,
               SquadPop = 6,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22136"),
               BP = OMGSBPS.ALLY.RANGERS,
               exp = 0.0000,
               SquadPop = 6,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
         },
         {
            PlatoonID = "1x4x2",
            Pop = 15,
            CallInTimeModifier = 1,
            NotAvailUntil = 0,
            Squadnumber = 2,
            Glider = false,
            ParaDrop = false,
            Infiltrate = false,
            HalfTrack = false,
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22137"),
               BP = OMGSBPS.ALLY.AMBUSH,
               exp = 0.0000,
               SquadPop = 3,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22138"),
               BP = OMGSBPS.ALLY.SHERMAN,
               exp = 0.0000,
               SquadPop = 12,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
         },
         {
            PlatoonID = "1x5x5",
            Pop = 8,
            CallInTimeModifier = 1,
            NotAvailUntil = 0,
            Squadnumber = 2,
            Glider = false,
            ParaDrop = false,
            Infiltrate = false,
            HalfTrack = false,
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22139"),
               BP = OMGSBPS.ALLY.QUAD,
               exp = 0.0000,
               SquadPop = 6,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22140"),
               BP = OMGSBPS.ALLY.JEEP,
               exp = 0.0000,
               SquadPop = 2,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
         },
         {
            PlatoonID = "1x2x1",
            Pop = 8,
            CallInTimeModifier = 1,
            NotAvailUntil = 0,
            Squadnumber = 1,
            Glider = false,
            ParaDrop = false,
            Infiltrate = false,
            HalfTrack = false,
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22141"),
               BP = OMGSBPS.ALLY.SNIPER,
               exp = 0.0000,
               SquadPop = 8,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
         },
      }
   elseif Player[pid].Name == "CPU - Easy" then
      Player[pid].Race = 2
      Player[pid].Doctrine = OMGUPG.AXIS.DEFENSEDOC
      Player[pid].Arrival = 5
      Player[pid].Para_Extra_Time = 15
      Player[pid].Glider_Extra_Time = 15
      Player[pid].Report_Delay = 10
      Player[pid].CompanyId = 937
      Player[pid].GliderSpawning = true
      Player[pid].Abilities = {

      }
      --table.insert(Player[pid].Abilities, abiltiy blueprint)
      Player[pid].Buildings = {

      }
      Player[pid].Platoons = {
         {
            PlatoonID = "1x1x1",
            Pop = 15,
            CallInTimeModifier = 1,
            NotAvailUntil = 0,
            Squadnumber = 1,
            Glider = false,
            ParaDrop = false,
            Infiltrate = false,
            HalfTrack = false,
            {
               SGroup = SGroup_CreateIfNotFound("SGroup22085"),
               BP = OMGSBPS.AXIS.PANTHER,
               exp = 0.0000,
               SquadPop = 15,
               Upgrades = {

               },
               HalfTrack_Check = false
            },
         },
      }
   end
end'

  # Create prec SCAR file
  # File.open("battle_#{battleid}.prec.scar", "wb") do |f|
  #   f.write(file_contents)
  # end
  # # Create SCAR file
  # File.open("battle_#{battleid}.scar", "wb") do |f|
  #   f.write(file_contents)
  # end
  #
  # file = File.open("battle_#{battleid}.scar", "rb")
  # file_contents = file.read

  # tocData section
  iDirCount = 2
  iFileCount = 1
  sFileName = "omg_battlefile.scar"
  tocData = ''
  tocData << [24, 1, 24 + 138, iDirCount, 24 + 138 + 12 * iDirCount, iFileCount, 24 + 138 + 12 * iDirCount + 22 * iFileCount, iFileCount + iDirCount].pack('LSLSLSLS')
  sTocName = 'data'
  (sTocName.size...64).each do
    sTocName << "\x00"
  end
  tocData << sTocName

  sTocTitle = "Sun, 25 Sep 2022 02:05:12 +0000" #Time.now.strftime("%a, %d %b %Y %k:%M:%S %z") # Sun, 25 Sep 2022 02:05:12 +0000
  (sTocTitle.size...64).each do
    sTocTitle << "\x00"
  end
  tocData << sTocTitle
  tocData << [0, iDirCount, 0, iFileCount, 0].pack('SSSSS')
  tocData << [0, 1, 2, 0, 0].pack('LSSSS')
  tocData << [1, 2, 2, 0, 1].pack('LSSSS')
  iFileSize = file_contents.size
  puts "File size: #{iFileSize}"

  tocData << [6, 260, iFileSize, iFileSize, 0, 0].pack('LLLLLS')
  tocData << "\0scar\0#{sFileName}\0"
  preData = sFileName
  (preData.size...256).each do
    preData << "\x00"
  end
  fileCRC = [Zlib::crc32(file_contents)].pack('L')
  
  # headerData
  headerData = "_ARCHIVE"
  headerData << [4].pack("L")
  md5DataKey = [Digest::MD5.hexdigest("E01519D6-2DB7-4640-AF54-0A23319C56C3#{tocData}#{preData}#{fileCRC}#{file_contents}".force_encoding("ASCII-8BIT"))].pack('H*')
  headerData << md5DataKey

  sArchiveTitle = "P\x00h\x00i\x00l\x00s\x00"
  (sArchiveTitle.size...128).each do
    sArchiveTitle << "\x00"
  end
  headerData << sArchiveTitle

  md5toc = [Digest::MD5.hexdigest("DFC9AF62-FC1B-4180-BC27-11CCE87D3EFF#{tocData}".force_encoding("ASCII-8BIT"))].pack('H*')
  headerData << md5toc
  tocSize = tocData.size
  headerData << [tocSize, tocSize + 0xB8].pack('LL')
  headerData << [1].pack('L')

  File.open('header.sga', "wb") do |f|
    f.write(headerData)
  end

  if headerData.size != 184
    Rails.logger.error("Failed Battlefile creation due to header size mismatch (ID: $battleid)")
  end

  if tocData.size != 24 + 138 + 12 + 12 + 22 + 26
    Rails.logger.error("Failed Battlefile creation due to TOC size mismatch (ID: #{battleid})")
  end

  sga = headerData + tocData + preData + fileCRC + file_contents

  File.open('OperationMarketGardenBattle.sga', "wb") do |f|
    f.write(sga)
  end
end