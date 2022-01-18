# frozen_string_literal: true

RSpec.shared_context 'http mock' do
  let(:http) { instance_double(Net::HTTP) }
  before do
    allow(client).to receive(:http).and_return(http)
    allow(http).to receive(:start).and_yield(http)
    allow(http).to receive(:request).and_return(res)
    allow(res).to receive(:body).and_return(res_body)
  end
end

RSpec.shared_context 'successful response' do
  let(:res) do
    Net::HTTPOK.new(nil, 200, 'OK').tap do |res|
      res.content_type = 'application/json;'
    end
  end
end

RSpec.shared_context 'error response' do
  let(:res) do
    Net::HTTPOK.new(nil, 400, 'Bad Request').tap do |res|
      res.content_type = 'application/json;'
    end
  end
end

RSpec.shared_examples 'returning the REST API response object' do
  include_context 'http mock'
  include_context 'successful response'
  let(:res_obj) { { property: 'property value' } }
  let(:res_body) { JSON.dump(res_obj) }
  it {
    expect(http).to receive(:request).with(
      have_attributes(method: command.to_s.upcase, path: URI.parse(path).to_s)
        .and(satisfy { |req| req['Authorization'] == "Bearer #{token}" }),
      expected_req_body
    )
    is_expected.to eq(res_obj)
  }
end

RSpec.shared_examples 'rising an error' do
  let(:err_obj) { { code: 'error code' } }
  let(:res_body) { JSON.dump({ error: err_obj }) }
  it {
    expect { subject }.to raise_error(MSGraph::Error) { |e| e.error == err_obj }
  }
end

RSpec.describe MSGraph::Client, '#request' do
  let(:client) { MSGraph::Client.new }
  let(:path) { '/path?$param=parameter value' }
  let(:token) { 'TOKEN_STRING' }
  context 'with data argument' do
    let(:command) { :get }
    subject { client.request(command, path, token) }
    include_examples 'returning the REST API response object' do
      let(:expected_req_body) { nil }
    end
  end
  context 'without data argument' do
    let(:command) { :post }
    let(:data) { { param: 'parameter value' } }
    subject { client.request(command, path, token, data) }
    include_examples 'returning the REST API response object' do
      let(:expected_req_body) { JSON.dump(data) }
    end
  end
  context 'with an error response' do
    let(:command) { :get }
    subject { client.request(command, path, token) }
    include_examples 'rising an error'
  end
end
