require 'rails_helper'

RSpec.describe "Sightings", type: :request do
  let(:animal1){ Animal.create!({
    common_name: 'mouse',
    latin_name: 'mus musculus',
    kingdom: 'mammal'
  }) }
  let(:animal2){ Animal.create!({
    common_name: 'monitor lizard',
    latin_name: 'varanus',
    kingdom: 'reptile'
  }) }
  let(:animal3){ Animal.create!({
    common_name: 'bald eagle',
    latin_name: 'haliaeetus leucocephalus',
    kingdom: 'raptor'
  }) }

  before do
    animal1
    animal2
    animal3
  end

  describe 'create' do
    let(:date){ Time.zone.parse(DateTime.now.iso8601).utc }
    let(:latitude){ 104.3456 }
    let(:longitude){ 9993314.32634 }
    let(:request){ post '/sightings', params: {
      sighting: {
        date: date,
        latitude: latitude,
        longitude: longitude,
        animal_id: animal2.id,
      }
    } }
    let(:expected_response){ {
      'date' => date.to_time.iso8601[0..18]+'.000Z',
      'latitude' => latitude,
      'longitude' => longitude,
      'animal_id' => animal2.id,
    } }
    it 'creates a new sighting for animal2' do
      expect{ request }.to change{Sighting.count}.by (1)
      expect(JSON.parse(response.body)).to include expected_response
    end
  end
end
