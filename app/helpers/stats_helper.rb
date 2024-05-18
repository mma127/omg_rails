module StatsHelper
  def upgrade_const_name(upgrade)
    if upgrade['constname'].present? && upgrade['faction'].present?
      "#{upgrade['faction']}.#{upgrade['constname']}"
    else
      nil
    end
  end

  def format_reference_as_name(reference)
    title = reference.split("/").last.titleize
    replace_spelling(title)
  end

  # There are a number of misspellings in the SGA reference names
  # We should also format anything strings that are mis-capitalized by #titleize
  def replace_spelling(title)
    if title.include?('Smg')
      title = title.gsub('Smg', 'SMG')
    end

    if title.include?('Mmg')
      title = title.gsub('Mmg', 'MMG')
    end

    if title.include?('Lmg')
      title = title.gsub('Lmg', 'LMG')
    end

    if title.include?('Hmg')
      title = title.gsub('Hmg', 'HMG')
    end

    if title.include?('Mg')
      title = title.gsub('Mg', 'MG')
    end

    if title.include?('Fsj')
      title = title.gsub('Fsj', 'FSJ')
    end

    if title.include?('Fg')
      title = title.gsub('Fg', 'FG')
    end

    if title.include?('Aa')
      title = title.gsub('Aa', 'AA')
    end

    if title.include?('Apcr')
      title = title.gsub('Apcr', 'APCR')
    end

    if title.include?('Atg')
      title = title.gsub('Atg', 'ATG')
    end

    if title.include?('Atw')
      title = title.gsub('Atw', 'ATW')
    end

    if title.include?('At ')
      title = title.gsub('At ', 'AT ')
    end

    if title.include?(' At')
      title = title.gsub(' At', ' AT')
    end

    if title.include?('Mg42')
      title = title.gsub('Mg42', 'MG42')
    end

    if title.include?('Mp40')
      title = title.gsub('Mp40', 'MP40')
    end

    if title.include?('Mp44')
      title = title.gsub('Mp44', 'MP44')
    end

    if title.include?('Stg44')
      title = title.gsub('Stg44', 'StG44')
    end

    if title.include?('Stg45')
      title = title.gsub('Stg45', 'StG45')
    end

    if title.include?('Grw')
      title = title.gsub('Grw', 'GrW')
    end

    if title.include?('M1919a4')
      title = title.gsub('M1919a4', 'M1919A4')
    end

    if title.include?('Pak')
      title = title.gsub('Pak', 'PaK')
    end

    if title.include?('Stug')
      title = title.gsub('Stug', 'StuG')
    end

    if title.include?('Stuk')
      title = title.gsub('Stuk', 'StuK')
    end

    if title.include?('Stup')
      title = title.gsub('Stup', 'StuP')
    end

    if title.include?('Iv')
      title = title.gsub('Iv', 'IV')
    end

    if title.include?('Td')
      title = title.gsub('Td', 'TD')
    end

    if title.include?('Cw')
      title = title.gsub('Cw', 'CW')
    end

    if title.include?('Cmw')
      title = title.gsub('Cmw', 'CMW')
    end

    if title.include?('Oqf')
      title = title.gsub('Oqf', 'OQF')
    end

    if title.include?('Qf')
      title = title.gsub('Qf', 'QF')
    end

    if title.include?('Omg')
      title = title.gsub('Omg', 'OMG')
    end

    if title.include?('Ef')
      title = title.gsub('Ef', 'EF')
    end

    if title.include?('Pe')
      title = title.gsub('Pe', 'PE')
    end

    if title.include?('Marderiii')
      title = title.gsub('Marderiii', 'MarderIII')
    end

    if title.include?('Panzeriv')
      title = title.gsub('Panzeriv', 'PanzerIV')
    end

    if title.include?('Pziv')
      title = title.gsub('Pziv', 'PzIV')
    end

    if title.include?('Kwk')
      title = title.gsub('Kwk', 'KwK')
    end

    if title.include?('Sfh')
      title = title.gsub('Sfh', 'sFH')
    end

    if title.include?('E80')
      title = title.gsub('E80', 'Easy 8')
    end

    if title.include?('M2a1')
      title = title.gsub('M2a1', 'M2A1')
    end

    if title.include?('M2hb')
      title = title.gsub('M2hb', 'M2HB')
    end

    if title.include?('M1a1c')
      title = title.gsub('M1a1c', 'M1A1C')
    end

    if title.include?('M1a1')
      title = title.gsub('M1a1', 'M1A1')
    end

    if title.include?('M1903a4')
      title = title.gsub('M1903a4', 'M1903A4')
    end

    if title.include?('M1919a6')
      title = title.gsub('M1919a6', 'M1919A6')
    end

    if title.include?('Hvap')
      title = title.gsub('Hvap', 'HVAP')
    end

    if title.include?('PErshing')
      title = title.gsub('PErshing', 'Pershing')
    end

    if title.include?('Ssf')
      title = title.gsub('Ssf', 'SSF')
    end

    if title.include?('Sas')
      title = title.gsub('Sas', 'SAS')
    end

    if title.include?('Avre')
      title = title.gsub('Avre', 'AVRE')
    end

    if title.include?('Piat')
      title = title.gsub('Piat', 'PIAT')
    end

    if title.include?('Ap')
      title = title.gsub('Ap', 'AP')
    end

    if title.include?('Assualt')
      title = title.gsub('Assualt', 'Assault')
    end

    if title.include?('Mortor')
      title = title.gsub('Mortor', 'Mortar')
    end

    if title.include?('Walter')
      title = title.gsub('Walter', 'Airborne Sniper')
    end

    if title.include?('Yagdpanther')
      title = title.gsub('Yagdpanther', 'Jagdpanther')
    end

    title
  end
end
