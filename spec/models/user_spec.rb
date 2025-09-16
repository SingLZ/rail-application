require 'rails_helper'

RSpec.describe User, type: :model do
  it 'returns the full_name for a user' do
    user = User.create(first_name: 'Sing', last_name: 'Zheng')

    expect(user.full_name).to eq('Sing Zheng')
  end
end
