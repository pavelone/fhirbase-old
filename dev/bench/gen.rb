def gen_identifier(number)
  tpls = [
    { use: 'official', label: 'BSN', system: 'urn:oid:2.16.840.1.113883.2.4.6.3', value: '123123' },
    { use: "official", label:"SSN", system:"urn:oid:2.16.840.1.113883.2.4.6.7", value:"123456789" }]
  number.times.map do
    tpls.sample.merge value: (1000000 + rand(1000000)).to_s, use: %w(usual  official  temp  secondary).sample
  end
end

def gen_patient(number)
  res = { resourceType: 'Patient' }
  #contained

  %i(identifier category name telecom gender birthDate deceasedBoolean address maritalStatus photo contact communication).each do |name|
    res[name] = send("gen_#{name}")
  end
end
