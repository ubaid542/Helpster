class SeedsController < ApplicationController
  def run
    if Rails.env.production?
      load Rails.root.join('db', 'seeds.rb')
      render plain: "Seed data created successfully!"
    else
      render plain: "Seeding is only allowed in production.", status: :forbidden
    end
  end
end
