(() => {
  var __require = /* @__PURE__ */ ((x) => typeof require !== "undefined" ? require : typeof Proxy !== "undefined" ? new Proxy(x, {
    get: (a, b) => (typeof require !== "undefined" ? require : a)[b]
  }) : x)(function(x) {
    if (typeof require !== "undefined")
      return require.apply(this, arguments);
    throw Error('Dynamic require of "' + x + '" is not supported');
  });

  // js/app.js
  var import_phoenix = __require("phoenix");
  var import_phoenix_live_view = __require("phoenix_live_view");
  var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
  var liveSocket = new import_phoenix_live_view.LiveSocket("/live", import_phoenix.Socket, {
    params: { _csrf_token: csrfToken }
  });
  liveSocket.connect();
})();
