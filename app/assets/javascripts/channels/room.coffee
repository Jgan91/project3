App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->

  disconnected: ->

  received: ( data ) ->
    console.log data
    $( "#messages" ).prepend data[ "message" ]
    $( "#players" ).html data[ "player" ]
    $( "#game_cards" ).append data[ "game_card" ]
    if data[ "start_game" ]
      console.log data
      $( ".starting-hand" ).fadeIn()

  speak: ( message ) ->
    @perform 'speak', message: message

$( document ).on "click", "[data-behavior~=room_speaker]", ( event ) ->
  if event.target.id is "join"
    App.room.speak { "join": "join" }

    event.preventDefault()

$( document ).on "click", "[data-behavior~=room_speaker]", ( event ) ->
  if event.target.id is "start-game"
    console.log "start game"
    App.room.speak "start-game"

    event.preventDefault()

$( document ).on "click", "[data-behavior~=room_speaker]", ( event ) ->
  if event.target.id is "hit"
    console.log "User HIT"
    App.room.speak { "user_action": "hit" }

    event.preventDefault()

$( document ).on "click", "[data-behavior~=room_speaker]", ( event ) ->
  if event.target.id is "stay"
    console.log "User STAY"
    App.room.speak { "user_action": "stay" }

    event.preventDefault()
