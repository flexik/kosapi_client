require 'spec_helper'

describe KOSapiClient::Entity::ResultPage do

  ResultPage = KOSapiClient::Entity::ResultPage

  subject(:result_page) { ResultPage.new([item], links) }
  let(:item) { double(:item) }
  let(:item2) { double(:second_item) }
  let(:links) { instance_double(KOSapiClient::ResponseLinks, next: next_link) }
  let(:next_page) { ResultPage.new([item2], instance_double(KOSapiClient::ResponseLinks, next: nil)) }
  let(:next_link) { instance_double(KOSapiClient::Entity::Link, follow: next_page) }

  describe '#each' do

    it 'is auto-paginated by default' do
      [item, item2].each { |it| expect(it).to receive(:foo) }
      result_page.each { |it| it.foo }
    end

    context 'with auto-pagination disabled' do

      subject(:result_page) { ResultPage.new([item], links, false) }

      it 'is not auto-paginated' do
        expect(item).to receive(:foo)
        expect(item2).not_to receive(:foo)
        result_page.each { |it| it.foo }
      end
    end

  end

  describe '#count' do

    it 'returns item count' do
      expect(result_page.count).to eq 1
    end

  end

end
