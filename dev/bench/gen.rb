# require 'faker'

def gen_identifier(number = 1)
  tpls = [
    { use: 'official', label: 'BSN', system: 'urn:oid:2.16.840.1.113883.2.4.6.3', value: '123123' },
    { use: "official", label:"SSN", system:"urn:oid:2.16.840.1.113883.2.4.6.7", value:"123456789" }]
  number.times.map do
    tpls.sample.merge value: (1000000 + rand(1000000)).to_s, use: %w(usual  official  temp  secondary).sample
  end
end

def gen_category ; end
def gen_name ; end
def gen_telecom ; end
def gen_gender ; end
def gen_birthDate ; end
def gen_deceasedBoolean ; end
def gen_address ; end
def gen_maritalStatus ; end
def gen_photo ; end
def gen_contact ; end
def gen_communication ; end
def gen_careProvider ; end
def gen_managingOrganization ; end


def gen_active(number = 1)
  [true, false].sample
end

def gen_patient(number)
  res = { resourceType: 'Patient' }
  #contained

  %i(identifier category name telecom gender birthDate deceasedBoolean address maritalStatus photo contact communication careProvider managingOrganization active).each do |name|
    res[name] = send("gen_#{name}")
  end

  res
end
