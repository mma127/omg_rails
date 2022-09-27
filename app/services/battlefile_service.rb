require 'tempfile'

class BattlefileService

  # To download with temp url: Rails.application.routes.url_helpers.rails_blob_url(Battle.last.battlefile)

  def generate_battlefile(battle_id, scar_contents)
    battle = Battle.find(battle_id)

    raise "Battle #{battle_id} not found" unless battle.present?

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

    sTocTitle = Time.now.utc.strftime("%a, %d %b %Y %k:%M:%S %z") # Sun, 25 Sep 2022 02:05:12 +0000
    (sTocTitle.size...64).each do
      sTocTitle << "\x00"
    end
    tocData << sTocTitle
    tocData << [0, iDirCount, 0, iFileCount, 0].pack('SSSSS')
    tocData << [0, 1, 2, 0, 0].pack('LSSSS')
    tocData << [1, 2, 2, 0, 1].pack('LSSSS')
    iFileSize = scar_contents.size

    tocData << [6, 260, iFileSize, iFileSize, 0, 0].pack('LLLLLS')
    tocData << "\0scar\0#{sFileName}\0"
    preData = sFileName
    (preData.size...256).each do
      preData << "\x00"
    end
    fileCRC = [Zlib::crc32(scar_contents)].pack('L')

    # headerData
    headerData = "_ARCHIVE"
    headerData << [4].pack("L")
    md5DataKey = [Digest::MD5.hexdigest("E01519D6-2DB7-4640-AF54-0A23319C56C3#{tocData}#{preData}#{fileCRC}#{scar_contents}".force_encoding("ASCII-8BIT"))].pack('H*')
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

    if headerData.size != 184
      Rails.logger.error("Failed Battlefile creation due to header size mismatch (ID: #{battle_id})")
    end

    if tocData.size != 24 + 138 + 12 + 12 + 22 + 26
      Rails.logger.error("Failed Battlefile creation due to TOC size mismatch (ID: #{battle_id})")
    end

    sga = headerData + tocData + preData + fileCRC + scar_contents

    Tempfile.create(binmode: true) do |f|
      f << sga
      f.rewind
      battle.battlefile.attach(io: f, filename: "OperationMarketGardenBattle.sga")
    end
  end
end
