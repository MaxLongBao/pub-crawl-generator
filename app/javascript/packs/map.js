import mapboxgl from 'mapbox-gl';
import places from 'places.js'

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  const response = JSON.parse(mapElement.dataset.response);
  const imageUrl = JSON.parse(mapElement.dataset.imageUrl);
  console.log(imageUrl);
  if (!response) {
    console.log("API FAILED")
  }
  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
  };
  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });
    const pub_markers = JSON.parse(mapElement.dataset.pubmarkers);
    console.log(pub_markers);
    const markers = JSON.parse(mapElement.dataset.markers);
    markers.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);
    });
    pub_markers.forEach((marker) => {
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url('${imageUrl}')`;
      element.style.backgroundSize = 'contain';
      element.style.width = '25px';
      element.style.height = '25px';
      new mapboxgl.Marker(element)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);
    });
    fitMapToMarkers(map, markers);
    if (response) {
      var data = response.routes[0]
      var route = data.geometry.coordinates;

      var geojson = {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'LineString',
          coordinates: route
        }
      }
      map.addLayer({
        id: 'route',
        type: 'line',
        source: {
          type: 'geojson',
          data: {
            type: 'Feature',
            properties: {},
            geometry: {
              type: 'LineString',
              coordinates: geojson
            }
          }
        },
        layout: {
            'line-join': 'round',
            'line-cap': 'round'
        },
        paint: {
          'line-color': '#3887be',
          'line-width': 5,
          'line-opacity': 0.75
        }
      });
    }
  }

};

const addressInput = document.getElementById('crawl_start_location');

if (addressInput) {
    places({ container: addressInput });
}

const addressendInput = document.getElementById('crawl_end_location');

if (addressendInput) {
    places({ container: addressendInput });
}

export { initMapbox, initAutocomplete};



