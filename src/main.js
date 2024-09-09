import { Elm } from './App.elm'

const app = Elm.App.init({
  node: document.getElementById("app")
});

document.getElementById('reset-button').addEventListener('click', function() {
  app.ports.reset.send("reset");
});

