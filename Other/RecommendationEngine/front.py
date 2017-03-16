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
#	weights should be in the range [0,1]
#	weights should be increased by (factorWeight * 0.1 * gaussian(0.5, 0.2) - this will reduce the amounts that weights are increased for very high or very low weights
# 	weights should decrease by a greater amount than they increase so that when a user follows the advice the reduction is great to stop giving the user the same advice again
#	weights should be decreased by 0.05

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
	