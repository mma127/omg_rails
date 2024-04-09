# == Schema Information
#
# Table name: quotes
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # # After a new quote is committed to the DB,
  # # render the quotes/quotes.html.erb partial in the turbo_stream format with action prepend and target "quotes"
  # # Run async as a Turbo::Streams::BroadcastJob
  # after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # # is the same as:
  # # after_create_commit -> { broadcast_prepend_to "quotes", partial: "admin/quotes/quote", locals: { quote: self }, target: "quotes" }
  # # by convention, target name is model_name.pluralize, so don't need to include
  # # by convention, partial path is equal to calling #to_partial_path on an instance of the model
  # # by convention, the locals default value is equal to model_name.element.to_sym => self
  #
  # after_update_commit -> { broadcast_replace_later_to "quotes" }
  # after_destroy_commit -> { broadcast_remove_to "quotes" }

  # is the same as:
  broadcasts_to ->(quote) { "quotes" }, inserts_by: :prepend
  # Users that should share the same broadcast should have the lambda return an array with the same values

  # Override to_partial_path
  def to_partial_path
    "admin/quotes/quote"
  end
end
