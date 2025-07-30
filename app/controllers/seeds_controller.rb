class SeedsController < ApplicationController
  def run
      load Rails.root.join('db', 'seeds.rb')
      render plain: "Seed data created successfully!"
    
      render plain: "Seeding is only allowed in production.", status: :forbidden
  end
end
