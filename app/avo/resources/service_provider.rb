class Avo::Resources::ServiceProvider < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :email, as: :text
    field :type, as: :text
    field :full_name, as: :text
    field :phone_number, as: :text
    field :category, as: :text
    field :experience_years, as: :text
    field :short_info, as: :textarea
    field :country, as: :country
    field :province, as: :text
    field :city, as: :text
    field :address, as: :textarea
    field :subcategories, as: :textarea
    field :bookings, as: :has_many
  end
end
