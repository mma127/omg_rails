after :units do

  REPLACEMENT_VET = {
    "PE.TH_VAMPIRE": "PE.VAMPIRE",

  }.with_indifferent_access

  def get_unit_const(unit)
    const = unit.const_name

    if REPLACEMENT_VET.keys.include?(const)
      REPLACEMENT_VET[const]
    else
      const
    end
  end

  def split_vet_string(str)
    str.split(';')
  end

  const_to_vet_hash = {}
  CSV.foreach('db/seeds/unit_vet.csv', headers: true) do |row|
    next if row["CONSTNAME"].blank?

    const = row["CONSTNAME"].strip
    vet1 = row["Vet1"]
    vet2 = row["Vet2"]
    vet3 = row["Vet3"]
    vet4 = row["Vet4"]
    vet5 = row["Vet5"]
    const_to_vet_hash[const] = { vet1: vet1, vet2: vet2, vet3: vet3, vet4: vet4, vet5: vet5 }
  end

  unit_vets = []
  Unit.all.each do |unit|
    const = get_unit_const(unit)

    vet_hash = const_to_vet_hash[const]

    raise StandardError.new("no unit vet for const #{const}") if vet_hash.blank?

    vet1_exp = split_vet_string(vet_hash[:vet1])[0]
    vet1_desc = split_vet_string(vet_hash[:vet1])[1]
    vet2_exp = split_vet_string(vet_hash[:vet2])[0]
    vet2_desc = split_vet_string(vet_hash[:vet2])[1]
    vet3_exp = split_vet_string(vet_hash[:vet3])[0]
    vet3_desc = split_vet_string(vet_hash[:vet3])[1]
    vet4_exp = split_vet_string(vet_hash[:vet4])[0]
    vet4_desc = split_vet_string(vet_hash[:vet4])[1]
    vet5_exp = split_vet_string(vet_hash[:vet5])[0]
    vet5_desc = split_vet_string(vet_hash[:vet5])[1]

    values = {unit: unit, vet1_exp: vet1_exp, vet1_desc: vet1_desc, vet2_exp: vet2_exp, vet2_desc: vet2_desc,
              vet3_exp: vet3_exp, vet3_desc: vet3_desc, vet4_exp: vet4_exp, vet4_desc: vet4_desc,
              vet5_exp: vet5_exp, vet5_desc: vet5_desc}
    puts "#{const} vet values #{values}"

    unit_vets << UnitVet.new(values)
  end

  UnitVet.import!(unit_vets)
end
