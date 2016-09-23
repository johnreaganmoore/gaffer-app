# jQuery ->
#
#   markersArray = []
#
#   window.initMap = ->
#     if $('#season-map').size() > 0
#       console.log($('#season-map').size())
#       map = new google.maps.Map document.getElementById('season-map'), {
#         center: {lat: -34.397, lng: 150.644}
#         zoom: 8
#       }
#       console.log(map)

      # map.addListener 'click', (e) ->
      #   placeMarkerAndPanTo e.latLng, map
      #   updateFields e.latLng
      #
      # placeMarkerAndPanTo = (latLng, map) ->
      #   markersArray.pop().setMap(null) while(markersArray.length)
      #   marker = new google.maps.Marker
      #     position: latLng
      #     map: map
      #
      #   map.panTo latLng
      #   markersArray.push marker
