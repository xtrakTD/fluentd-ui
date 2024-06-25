const POLLING_INTERVAL = 3 * 1000;
const POLLING_URL = "/polling/alerts";

window.addEventListener("load", () => {
  new Vue({
    el: "#mainNav",
    data: function() {
      return {
        alerts: []
      };
    },

    computed: {
      alertsCount: {
        get: function() { return this.alerts.length; }
      },
      hasAlerts: {
        get: function() { return this.alertsCount > 0; }
      }
    },

    created: function(){
      let timer;
      let self = this;
      let currentInterval = POLLING_INTERVAL;
      let fetch = function(){
        self.fetchAlertsData().then(function(alerts){
          if(self.alerts.toString() == alerts.toString()) {
            currentInterval *= 1.1;
          } else {
            currentInterval = POLLING_INTERVAL;
          }
          self.alerts = alerts;
          timer = setTimeout(fetch, currentInterval);
        })["catch"](function(xhr){
          if(xhr.status === 401) {
            // signed out
          }
          if(xhr.status === 0) {
            // server unreachable (maybe down)
          }
        });
      };
      window.addEventListener("focus", function(_event){
        currentInterval = POLLING_INTERVAL;
        timer = setTimeout(fetch, currentInterval);
      }, false);
      window.addEventListener("blur", function(_event){
        clearTimeout(timer);
      }, false);
      fetch();
    },

    methods: {
      fetchAlertsData: function() {
        return new Promise(function(resolve, reject) {
          $.getJSON(POLLING_URL, resolve).fail(reject);
        });
      }
    }
  });
});
