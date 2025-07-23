class Avo::Resources::Booking < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :client, as: :belongs_to
    field :service_provider, as: :belongs_to  
    field :service, as: :belongs_to
    field :date, as: :date
    field :time, as: :text
    field :address, as: :textarea, hide_on: [:index]
    field :notes, as: :textarea, hide_on: [:index]
    field :status, as: :select, options: ["pending", "confirmed", "cancelled", "completed"]
    field :price, as: :number, format_using: -> { "PKR #{value.to_i}" }
    field :created_at, as: :date_time, hide_on: [:new, :edit]
    field :updated_at, as: :date_time, hide_on: [:new, :edit]
  end
end