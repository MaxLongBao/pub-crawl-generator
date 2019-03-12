import mapboxgl from 'mapbox-gl';
import places from 'places.js'

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  const route = JSON.parse(mapElement.dataset.route);
  const response = JSON.parse(mapElement.dataset.response);
  const imageUrl = JSON.parse(mapElement.dataset.imageUrl);
  const pub_markers = JSON.parse(mapElement.dataset.pubmarkers);
  const markers = JSON.parse(mapElement.dataset.markers);
  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
  };
  mapboxgl.accessToken = 'pk.eyJ1IjoibXJldmFuczQyIiwiYSI6ImNqdDVrdWZqejA2d2QzeW1zd2d6a3lyZDUifQ.vCF837X1giyhWXfQJvqFmg';
  var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/mapbox/streets-v9',
  });

  map.on('load', function () {
  console.log(route)
  map.addLayer({
  "id": "route",
  "type": "line",
  "source": {
  "type": "geojson",
  "data": {
  "type": "Feature",
  "properties": {},
  "geometry": {
  "type": "LineString",
  "coordinates": route
  }
  }
  },
  "layout": {
  "line-join": "round",
  "line-cap": "round"
  },
  "paint": {
  "line-color": "#32979F",
  "line-width": 4
  }
  });
  });
  markers.forEach((marker) => {
    new mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .addTo(map);
  });
  pub_markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
    const element = document.createElement('div');
    element.className = 'marker';
    element.style.backgroundImage = `url('${imageUrl}')`;
    element.style.backgroundSize = 'contain';
    element.style.width = '25px';
    element.style.height = '25px';
    new mapboxgl.Marker(element)
      .setLngLat([ marker.lng, marker.lat ])
      .setPopup(popup)
      .addTo(map);
  });
  fitMapToMarkers(map, markers);

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



