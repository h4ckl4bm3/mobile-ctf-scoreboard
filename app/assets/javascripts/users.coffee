# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
startTimer(endTime) ->
	countdown = (endTime) ->
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
		difference = countdown(new Date(endTime*1000))
		$("#hours").text(difference.hours.toString().paddingLeft("00")+ "h")
		$("#minutes").text(difference.minutes.toString().paddingLeft("00") + "m")
		$("#seconds").text(difference.seconds.toString().paddingLeft("00")+ "s")
	updateClock()
	setInterval(updateClock, 1000)
