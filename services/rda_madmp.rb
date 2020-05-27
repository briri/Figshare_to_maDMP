# frozen_string_literal: true

# This module converts Figshare JSON into RDA Common Standard JSON
module RdaMadmp
  def transform(json:)
    return nil if json.nil?

    {
      dmp: {
        dmp_id: {
          type: 'url', identifier: json['url_public_api']
        },
        title: json['title'],
        description: json['description'],
        contact: transform_contact(hash: json['authors'].first),
        contributor: transform_contributor(array: json['authors'].drop(1)),
        dataset: transform_dataset(json: json)
      }
    }
  end

  def transform_contact(hash:)
    {
      name: hash['full_name'],
      contact_id: {
        type: 'orcid', identifier: hash['orcid_id']
      }
    }
  end

  def transform_contributor(array:)
    return [] if array.nil?

    array.map do |item|
      # Hard-coding role here since it doesn't seem to be in the Figshare data
      {
        name: item['full_name'],
        contributor_id: {
          type: 'orcid', identifier: item['orcid_id']
        },
        role: ['https://dictionary.casrai.org/Contributor_Roles/Investigation']
      }
    end
  end

  def transform_funding(array:)
    return [] if array.nil?

    # TODO: I haven't found an example of a Figshare record that has :funding or
    #       :funding_list filled out yet
  end

  def transform_dataset(json:)
    # TODO: There musst be a better way to derive the title here
    [
      {
        title: "Dataset - #{json[:title]}",
        distribution: transform_distribution(array: json['files'],
                                             license: json['license'])
      }
    ]
  end

  def transform_distribution(array:, license: {})
    return [] if array.nil?

    array.map do |item|
      {
        title: item['name'],
        download_url: item['download_url'],
        byte_size: item['size'],
        license: {
          license_ref: license['url']
        }
      }
    end
  end
end
