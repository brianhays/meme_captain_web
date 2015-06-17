The Meme Captain API is currently experimental and may change.

# Creating a Meme Image

HTTP POST a JSON body to http://memecaptain.com/gend_images. For this
request set the `Accept` and `Content-Type` headers to `application/json`.
Example JSON body:

```json
{
  "src_image_id": "MDyuQg",
  "private": false,
  "captions_attributes": [
    {
      "text": "top text",
      "top_left_x_pct": 0.05,
      "top_left_y_pct": 0,
      "width_pct": 0.9,
      "height_pct": 0.25
    },
    {
      "text": "bottom text",
      "top_left_x_pct": 0.05,
      "top_left_y_pct": 0.75,
      "width_pct": 0.9,
      "height_pct": 0.25
    }
  ]
}
```

## Caption Coordinates

The top left corner of the image has the coordinates (0, 0).

- top_left_x_pct - the x coordinate of the top left corner of the caption as a percentage of the total image width
- top_left_y_pct - the y coordinate of the top left corner of the caption as a percentage of the total image height
- width_pct - the width of the caption as a percentage of the total image width
- height_pct - the height of the caption as a percentage of the total image height

## Polling

If the request is accepted you will receive an HTTP 202 Accepted response.
The `Location` header will contain a URL to poll.

Poll the URL returned in the `Location` header until it returns 303 (See
Other). When it returns 303, the image is finished processing and the
`Location` header will contain the URL of the image. Under normal
circumstances creation of the image should only take a few seconds.

## Ruby example

```ruby
#!/usr/bin/env ruby

require 'json'
require 'net/http'

json_request = {
  src_image_id: 'MDyuQg',
  private: false,
  captions_attributes: [
    {
      text: 'top text',
      top_left_x_pct: 0.05,
      top_left_y_pct: 0,
      width_pct: 0.9,
      height_pct: 0.25
    },
    {
      text: 'bottom text',
      top_left_x_pct: 0.05,
      top_left_y_pct: 0.75,
      width_pct: 0.9,
      height_pct: 0.25
    }
  ]
}

create_uri = URI('http://memecaptain.com/gend_images')
create_request = Net::HTTP::Post.new(create_uri)
create_request['Accept'] = 'application/json'
create_request['Content-Type'] = 'application/json'
create_request.body = json_request.to_json

Net::HTTP.start(create_uri.hostname, create_uri.port) do |http|
  create_response = http.request(create_request)

  poll_uri = URI(create_response['Location'])
  poll_request = Net::HTTP::Get.new(poll_uri)
  10.times do
    poll_response = http.request(poll_request)
    puts "poll response #{poll_response.code}"
    if poll_response.code == '303'
      puts poll_response['Location']
      break
    end
    sleep 3
  end
end
```