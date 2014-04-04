require 'faker'

def gen(number, &block)
  res = (rand(number + 1)).times.map(&block)
  res.empty? ? nil : res
end

def gen_identifier(number = 1)
  n = if number.is_a?(Range)
        number.last < Float::INFINITY ? number.last : 9
      else
        number
      end

  tpls = [
    { use: 'official', label: 'BSN', system: 'urn:oid:2.16.840.1.113883.2.4.6.3', value: '123123' },
    { use: "official", label:"SSN", system:"urn:oid:2.16.840.1.113883.2.4.6.7", value:"123456789" }]

  gen(3) do
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

def gen_category
  gen(3) do
    { scheme: Faker::Internet.url('http://hl7.org/fhir/tag/'), term: Faker::Internet.url, label: Faker::Lorem.sentence }
  end
end

def gen_name
  gen(1) do 
    {
      use: %w(usual  official  temp  nickname  anonymous  old  maiden).sample,
      text: Faker::Name.name,
      family: gen(2) { Faker::Name.last_name },
      given: gen(2) { Faker::Name.first_name },
      prefix: gen(1) { Faker::Name.prefix }
    }
  end
end

def gen_telecom
  gen(2) do
    [
      {
        system: %w(phone fax).sample,
        value: Faker::PhoneNumber.cell_phone,
        use: %w(home  work  temp  old  mobile).sample
      },
      {
        system: 'email',
        value: Faker::Internet.email,
        use: %w(home  work  temp  old  mobile).sample
      }
    ].sample
  end
end

def gen_gender
  gen(1) do
    {
      coding: [{ system: 'http://hl7.org/fhir/v3/AdministrativeGender', code: %w(M F).sample, display: %(Male Female).sample }] # bug
    }
  end
end

def gen_birthDate
  Time.at(rand * Time.now.to_i)
end

def deceasedBoolean
  rand % 100 == 0
end

def address
  gen(2) do
    res = { use: %w(home work temp old).sample,
      line: [Faker::Address.street_address],
      city: Faker::Address.city,
      zip: Faker::Address.zip,
      state: Faker::Address.state
    }
    res[:text] = [res[:line].join("\n"), res[:state], res[:zip]].join(", ")
    res
  end
end

def gen_patient(number)
  gen(number) do
    res = { resourceType: 'Patient' }

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
      res.delete_if { |k, v| v.nil? }
    end

    res
  end
end
