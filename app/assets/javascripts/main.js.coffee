$(document).on 'page:fetch', ->
  $('.content-wrapper').hide()
  $('.bubblingG').show()
  debugger

$(document).on 'page:receive', ->
  $('.bubblingG').hide()
  $('.content-wrapper').show()
