from suggestions import SuggestionEngine
import random
import operator

class RecommendationEngine(object):

	def __init__(self):
		# initialise to default factor weights
		self.factorWeights = {'duration': 0.4,
							'exercise': 0.4,
							'caffeine': 0.4,
							'meal': 0.4,
							'nicotine': 0.4,
							'alcohol': 0.4,
							'relaxation': 0.4,
							'light': 0.4,
							'noise': 0.4,
							'temperature': 0.4,
							'humidity': 0.4,
							'device': 0.4}
							
		self.factor = 'duration'
							
		# initialise suggestion engine settings
		self.suggestions = SuggestionEngine()
		self.suggestions.setSleepDuration(6)
		self.suggestions.setSleepStart(23)
		self.suggestions.setExerciseLevel(0)
		self.suggestions.setNumberCoffees(3)
		self.suggestions.setIsHot(False)
		self.suggestions.setColdTime(1)
		self.suggestions.setDeviceEffect(0)
		self.suggestions.setSmoker(False)
							
	def getSuggestion(self):
		# find factor with maximum weight (note: only 1 factor if multiple with same value)
		tempFactorWeights = self.factorWeights.copy()
		found = False
		while found == False:
			maxFactor = max(tempFactorWeights.iteritems(), key=operator.itemgetter(1))[0]
			advice = self.suggestions.getSuggestion(maxFactor)
			if advice == 'empty advice' or advice is None:
				tempFactorWeights = self.removeFactor(tempFactorWeights, maxFactor)
				if not tempFactorWeights:
					advice = 'no further advice to give'
					found = True
			else:
				found = True
		self.factor = maxFactor
		#return (maxFactor + ': ' + advice)
		return advice
		
	def rejectSuggestion(self, factor, suggestion):
		# rejected suggestions will be removed from the list of available suggestions
		self.suggestions.removeSuggestion(factor, suggestion)
							
	def setDurationWeight(self, n):
		self.factorWeights['duration'] = n
		
	def setExerciseWeight(self, n):
		self.factorWeights['exercise'] = n
	
	def setCaffeineWeight(self, n):
		self.factorWeights['caffeine'] = n
	
	def setMealWeight(self, n):
		self.factorWeights['meal'] = n
	
	def setNicotineWeight(self, n):
		self.factorWeights['nicotine'] = n
		
	def setAlcoholWeight(self, n):
		self.factorWeights['alcohol'] = n
		
	def setRelaxationWeight(self, n):
		self.factorWeights['relaxation'] = n
		
	def setLightWeight(self, n):
		self.factorWeights['light'] = n
		
	def setNoiseWeight(self, n):
		self.factorWeights['noise'] = n
	
	def setTemperatureWeight(self, n):
		self.factorWeights['temperature'] = n
	
	def setHumidityWeight(self, n):
		self.factorWeights['humidity'] = n
	
	def setDeviceWeight(self, n):
		self.factorWeights['device'] = n
		
	def removeFactor(self, d, s):
		del d[s]
		return d
		
	def getWeights(self):
		# returns weight dictionary for debugging purposes and display
		return self.factorWeights
	
		
	

#if __name__ == '__main__':
#	recommendation = RecommendationEngine()
#	weights = recommendation.getWeights()
#	print weights
#	recommendation.setDeviceWeight(0.6)
#	weights = recommendation.getWeights()
#	print weights
#	suggestion = recommendation.getSuggestion()
#	print suggestion
#	suggestions = SuggestionEngine()
#	i = 0
#	options = ('duration', 'exercise', 'caffeine', 'meal', 'nicotine', 'alcohol', 'relaxation', 'light', 'noise', 'temperature', 'humidity', 'device')
#	while (i < 20):
#		s = random.choice(options)
#		advice = suggestions.getSuggestion(s)
#		print s + ': ' + advice
#		i = i + 1