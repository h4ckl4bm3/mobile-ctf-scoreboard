$ ->
  endTime = window.endTime
  countdown = ->
    diff = endTime - new Date()
    diff = 0 if diff < 0
    hours = Math.floor(diff/1000/60/60)
    diff -= hours * 1000*60*60
    minutes = Math.floor(diff/1000/60)
    diff -= minutes * 1000*60
    seconds = Math.floor(diff/1000)
    return {"hours": hours, "minutes":minutes, "seconds":seconds}

  String.prototype.paddingLeft = (paddingValue) ->
    String(paddingValue + this).slice(-paddingValue.length)

  updateClock = () ->
    now = new Date()
    if endTime and endTime > now
      $("#timeless_text").hide()
      difference = countdown(new Date(endTime*1000))
      $("#hours").text(difference.hours.toString().paddingLeft("00")+ "h")
      $("#minutes").text(difference.minutes.toString().paddingLeft("00") + "m")
      $("#seconds").text(difference.seconds.toString().paddingLeft("00")+ "s")
    else if endTime
      $("#hours").text("00h")
      $("#minutes").text("00m")
      $("#seconds").text("00s")
      updateTime()
  updateClock()
  updateTime = () ->
    $.getJSON('/current_time.json', (timeObj)->
      if timeObj.time
        endTime = new Date(timeObj.time)
        $("#clock_text").show()
        $("#timeless_text").hide()
        periodType = if timeObj.attack then "Attack Period" else "Defense Period"
        if timeObj.countdown_to_end
          $("#time_text").text("Time Remaining in "+periodType+"=")
        else
          $("#time_text").text("Time Until "+periodType+" Begins=")
        updateClock()
      else
        $("#clock_text").hide()
        $("#timeless_text").show()
        endTime = null

      )

  setInterval(updateClock, 1000)
  setInterval(updateTime, 20000)
