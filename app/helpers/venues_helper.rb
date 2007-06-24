include Mapping

module VenuesHelper
  def map(id, venue, options = {})
    coords = (venue.latitude.nil? or venue.longitude.nil?) ? { :lat => -43.52409489870102, :long => 172.58052706718445 } : { :lat => venue.latitude, :long => venue.longitude }
    code = <<-END
      map = new GMap2(document.getElementById("map"));
      map.addControl(new GSmallMapControl());
      map.addControl(new GMapTypeControl());
      map.setCenter(new GLatLng(#{coords[:lat]}, #{coords[:long]}), 15);
    END
    
    if !(venue.latitude.nil? and venue.longitude.nil?)
      code += <<-END
        map.addOverlay(new GMarker(new GLatLng(#{coords[:lat]}, #{coords[:long]}), 15);
      END
    end
    
    if options[:editable]
      code += <<-END
        GEvent.addListener(map, "click", function(marker, point) {
          if (marker) {
            map.removeOverlay(marker);
          } else {
            map.addOverlay(new GMarker(point));
          }
        });
      END
    end
    
    javascript_tag <<-END
      var map;
      if (GBrowserIsCompatible()) {
        #{code}
      }
    END
  end
end
