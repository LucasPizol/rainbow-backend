class TemporaryFileSaver
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :file
  validates :file, presence: true

  def save
    random_code = SecureRandom.hex(10)
    file_ext = File.extname(file.original_filename)

    sanitized_filename = file.original_filename.to_s.parameterize.underscore + file_ext

    tmp_path = Rails.root.join('tmp/content', "tmp_#{random_code}_#{sanitized_filename}")

    file_test = File.open(tmp_path, 'wb') { |new_file| new_file.write(file.read) }

    tmp_path
  end
end
