require 'rails_helper'

RSpec.describe "Animals", type: :request do
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

  describe "index" do
    let(:request){ get '/animals' }
    let(:expected_response) {
      [{
        "id" => animal1.id,
        "common_name" => animal1.common_name,
        "latin_name" => animal1.latin_name,
        "kingdom" => animal1.kingdom,
      }, {
        "id" => animal2.id,
        "common_name" => animal2.common_name,
        "latin_name" => animal2.latin_name,
        "kingdom" => animal2.kingdom,
      }, {
        "id" => animal3.id,
        "common_name" => animal3.common_name,
        "latin_name" => animal3.latin_name,
        "kingdom" => animal3.kingdom,
      }]
    }

    it 'returns a list of all the items in JSON' do
      request
      expect(JSON.parse(response.body)["animals"]).to include(*expected_response)
    end
  end

  describe "show" do
    let(:request){ get "/animals/#{animal2.id}" }
    let(:expected_response) { {
      id: animal2.id,
      common_name: animal2.common_name,
      latin_name: animal2.latin_name,
      kingdom: animal2.kingdom,
    }.to_json }
    it 'shows only animal 2 from the database' do
      request
      expect(response.body).to eq expected_response
    end
  end

  describe "create" do
    let(:new_common){ "komodo dragon" }
    let(:new_latin){ "varanus komodoensis" }
    let(:request){ patch "/animals/#{animal2.id}", params: {
      animal: {
        common_name: new_common,
        latin_name: new_latin,
      }
    } }
    let(:request2){ get "/animals/#{animal2.id}" }
    let(:expected_response) { {
      "id" => animal2.id,
      "common_name" => new_common,
      "latin_name" => new_latin
    } }
    it 'edits the names of the monitor lizard to komodo dragon' do
      request
      request2
      expect(JSON.parse(response.body)).to include expected_response
      expect(animal2.reload.latin_name).to eq new_latin
    end
  end
end
