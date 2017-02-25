from recommendations import RecommendationEngine

# TODO: front end (app page) to display the suggestion and the factor weights
#	to get suggestion call recommendation.getSuggestion()
#	to get factor weights call recommendation.getWeights()
#	so far weights and suggestions exist for the following factors:
#		* duration
#		* exercise
#		* caffeine
#		* evening meals
#		* nicotine
#		* alcohol
#		* relaxation
#		* light
#		* noise
#		* temperature
#		* humidity
#		* device use
#	suggestions can be rejected by the user in the app
#		these suggestions can be rejected by calling rejectSuggestion(factor, suggestion)

# TODO: PCA/ thresholds to compute new factor weights
#	weights can be updated by calling the relevant one of the following functions:
#		setDurationWeight(newWeight)
#		setExerciseWeight(newWeight)
#		setCaffeineWeight(newWeight)
#		setMealWeight(newWeight)
#		setNicotineWeight(newWeight)
#		setAlcoholWeight(newWeight)
#		setRelaxationWeight(newWeight)
#		setLightWeight(newWeight)
#		setNoiseWeight(newWeight)
#		setTemperatureWeight(newWeight)
#		setHumidityWeight(newWeight)
#		setDeviceWeight(newWeight)

# TODO: find the default settings for the factor weights (currently all set to 0.4)

# TODO: find default behaviours to set before collecting the first night's data for and settings for the following:
#	* normal sleep duration (in integer/floating point number of hours)
#	* time the user usually goes to bed (given as integer number of the closest hour e.g. 23:10 becomes 23)
#	* exercise level of the user (0 = no exercise weekly, 1 = small amount weekly i.e. light/moderate exercise 1 to 4 times a week, 2 = regular moderate exercise)
#	* numbers of coffees consumed per day (integer number)
#	* if the room is not too cold (True = not too cold, False = too cold)
#	* the time of night at which the temperature drops to become too cold (given as integer number of the closest hour e.g. 23:10 becomes 23)
#	* the degree to which the use of a device before bed affests their sleep (0 = minor effect, 1 = major effect)
#	* whether they smoke
#	Set by calling the respective functions below:
#		self.suggestions.setSleepDuration(6)
#		self.suggestions.setSleepStart(23)
#		self.suggestions.setExerciseLevel(0)
#		self.suggestions.setNumberCoffees(3)
#		self.suggestions.setIsHot(False)
#		self.suggestions.setColdTime(1)
#		self.suggestions.setDeviceEffect(0)
#		self.suggestions.setSmoker(False)

# TODO: add more suggestions

if __name__ == '__main__':
	recommendation = RecommendationEngine()
	recommendation.setLightWeight(0.6)
	advice = recommendation.getSuggestion()
	print advice
	advice = recommendation.getSuggestion()
	print advice
	advice = recommendation.getSuggestion()
	print advice
	advice = recommendation.getSuggestion()
	print advice								# should see a new suggestion given (repeatition supressed)
	advice = recommendation.getSuggestion()
	print advice								# should see suggestion return to light related
	recommendation.rejectSuggestion(recommendation.factor, advice)
	advice = recommendation.getSuggestion()
	print advice								# should see a new suggestion given (repeatition supressed)
	