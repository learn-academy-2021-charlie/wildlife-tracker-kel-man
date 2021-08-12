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
  let(:sighting){ Sighting.create!({
    latitude: 1235326,
    longitude: 12342352,
    date: Time.zone.parse(DateTime.now.iso8601).utc,
    animal_id: animal2.id
  }) }

  before do
    animal1
    animal2
    animal3
    sighting
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

  describe 'update' do
    let(:new_lat){ 343251.62346 }
    let(:request){ patch "/sightings/#{sighting.id}", params: {
      sighting: {
        latitude: new_lat
      }
    } }
    let(:expected_response) { {
      'latitude' => new_lat,
      'longitude' => sighting.longitude,
      'date' => sighting.date,
      'animal_id' => sighting.animal_id
    } }
    it 'updates the latitude of the entry' do
      request
      expect(JSON.parse(response.body)).to include expected_response
      expect(sighting.reload.latitude).to eq new_lat
    end
  end

  describe 'destroy' do
    let(:request){ delete "/sightings/#{sighting.id}" }
    let(:expected_response){ {
      sightings: [{}]
    }.to_json }
    it 'destroys sighting from the database' do
      expect{ request }.to change{ Sighting.count }.by ( -1 )
      expect(response.status).to eq 204
      # get '/sightings'
      # expect(response.body).to eq expected_response
    end
  end
end
