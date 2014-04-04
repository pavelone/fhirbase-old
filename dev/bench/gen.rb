# require 'faker'

def gen_identifier(number = 1)
  n = if number.is_a?(Range)
        number.last < Float::INFINITY ? number.last : 9
      else
        number
      end

  tpls = [
    { use: 'official', label: 'BSN', system: 'urn:oid:2.16.840.1.113883.2.4.6.3', value: '123123' },
    { use: "official", label:"SSN", system:"urn:oid:2.16.840.1.113883.2.4.6.7", value:"123456789" }]
  n.times.map do
    tpls.sample.merge value: (1000000 + rand(1000000)).to_s, use: %w(usual  official  temp  secondary).sample
  end
end

def gen_category(number = 1) end
def gen_name(number = 1) end
def gen_telecom(number = 1) end
def gen_gender(number = 1) end
def gen_birthDate(number = 1) end
def gen_deceasedBoolean(number = 1) end
def gen_address(number = 1) end
def gen_maritalStatus(number = 1) end
def gen_photo(number = 1) end
def gen_contact(number = 1) end
def gen_communication(number = 1) end
def gen_careProvider(number = 1) end

def gen_managingOrganization(number = 1) #0..1
  res = {}


  res
end

def gen_active(number = 1) #0..1
  [true, false].sample
end

def gen_codeable_concept(number = 1)
  res = {}
  object :coding, (0..Float::INFINITY) do
    # Coding Code defined by a terminology system
  end
  res = string :text, 0..1 # Plain text representation of the concept

  res
end

def gen_patient(number)
  res = { resourceType: 'Patient' }
  #contained

  {
    identifier:           0..Float::INFINITY,
    category:             0, #wtf?
    name:                 0..Float::INFINITY,
    telecom:              0..Float::INFINITY,
    gender:               0..1,
    birthDate:            0..1,
    deceasedBoolean:      0..1,
    address:              0..Float::INFINITY,
    maritalStatus:        0..1,
    photo:                0..Float::INFINITY,
    contact:              0..Float::INFINITY,
    communication:        0..Float::INFINITY,
    careProvider:         0..Float::INFINITY,
    managingOrganization: 0..1,
    active:               0..1
  }.each do |name, number|
    res[name] = send("gen_#{name}", number)
  end

  res
end
