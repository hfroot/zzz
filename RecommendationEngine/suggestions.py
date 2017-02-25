import random

class SuggestionEngine(object):
	def __init__(self):
		# initialise suggestion groups and subgroups
		self.duration = [['tonight try to sleep for ', 1],
						['tonight try going to sleep at ', 1]]
						
		self.exercise = [['try to go jogging for 20 minutes today', 2],
						['try to go jogging for 40 minutes today', 2],
						['try to go running for 30 minutes today', 3],
						['try to go running for 1 hour today', 3],
						['continue exercising regularly', 19]]
						
		self.caffeine = [['today try cutting down to ', 20],
						['today try not to drink coffee after ', 20]]
						
		self.meal = [['make sure your supper has a good mix of carbohydrates and protein', 4],
					['make sure you eat at least one portion of vegatables at supper', 4],
					['remember, do not make your supper portion too big, you will be too full to sleep', 5],
					['make sure your supper is low in sugar', 4],
					['eat at least 4 hours before you plan to go to bed', 5]]
					
		self.nicotine = [['do not smoke within an hour of going to bed', 6]]
		
		self.alcohol = [['try to drink fewer units of alcohol this evening', 7],
						['avoid consuming alcohol after ', 7]]
						
		self.relaxation = [['try taking a warm (but not too hot) bath before bed', 8],
							['drink a decaffeinated tea before bed, such as chamomile', 9],
							['try a relaxation technique before bed, such as yoga or progressive muscule relaxation', 10],
							['try listening to some relaxing music before bed', 16]]
							
		self.light = [['try to make your room as dark as possible', 11],
					['try better blinds/curtains', 11]]
					
		self.noise = [['try closing your window at night to make your room quieter', 12],
					['try sleeping with earplugs, your room is too noisy', 12]]
					
		self.temperature = [['turn your heating up before you go to bed', 13],
							['set you heating time to come on after ', 13],
							['turn the radiator up in your room', 13],
							['turn your heating down before going to bed', 14],
							['try turning the radiator off in your room before going to bed', 14]]
							
		self.humidity = [['your room is too humid, try a de-humidifier', 15]]
		
		self.device = [['try turning the brightness down on your mobile devices after ', 17],
						['try not to use your mobile devices at all after ', 18]]
		
		self.setPrevious(0)
		self.setCurrent(0)
		self.setCount(0)

	def getSuggestion(self, group):
		# select a suggestion from the relevant group
		
		if group is 'duration':
			if not self.duration:
				return 'empty advice'
			advice = self.getDurationAdvice()
				
		elif group is 'exercise':
			if not self.exercise:
				return 'empty advice'
			advice = self.getExerciseAdvice()
			
		elif group is 'caffeine':
			if not self.caffeine:
				return 'empty advice'
			advice = self.getCaffeineAdvice()
			
		elif group is 'meal':
			if not self.meal:
				return 'empty advice'
			advice = self.getMealAdvice()
			
		elif group is 'nicotine':
			if not self.nicotine:
				return 'empty advice'
			advice = self.getNicotineAdvice()
			
		elif group is 'alcohol':
			if not self.alcohol:
				return 'empty advice'
			advice = self.getAlcoholAdvice()
			
		elif group is 'relaxation':
			if not self.relaxation:
				return 'empty advice'
			advice = self.getRelaxationAdvice()
			
		elif group is 'light':
			if not self.light:
				return 'empty advice'
			advice = self.getLightAdvice()
			
		elif group is 'noise':
			if not self.noise:
				return 'empty advice'
			advice = self.getNoiseAdvice()
			
		elif group is 'temperature':
			if not self.temperature:
				return 'empty advice'
			advice = self.getTemperatureAdvice()
			
		elif group is 'humidity':
			if not self.humidity:
				return 'empty advice'
			advice = self.getHumidityAdvice()
			
		elif group is 'device':
			if not self.device:
				return 'empty advice'
			advice = self.getDeviceAdvice()
			
		else:
			print 'group not defined'
			return
			
		
		# if a suggestion of the same subgroup has been repeated 3 times supress advice, i.e. return None
		if self.current != self.previous:
			self.setCount(1)
			
		elif self.count > 2:
			return
			
		else:
			self.setCount(self.count + 1)
		
		self.setPrevious(self.current)
		
		return advice
		
	def getDurationAdvice(self):
		# chose suggestion at random to change the duration of their sleep
		n = random.randint(0,1)
		if n == 0:
			# brings their sleep duration towards the optimal 8 to 9 hours
			if self.sleepDuration < 9:
				advice = (self.duration[0][0] + str(self.sleepDuration + 1) + ' hours')
			else:
				advice = (self.duration[0][0] + str(self.sleepDuration - 1) + ' hours')
		else:
			# go to bed one hour earlier than usual
			advice = (self.duration[1][0] + str(self.sleepStart - 1) + ':00')
		self.setCurrent(self.duration[n][1])
		return advice
		
	def getExerciseAdvice(self):
		# choose a random suggestion to encourage them to exercise
		# not exercising - do small amount of exercise
		if self.exerciseLevel == 0:
			n = random.randint(0,1)
			advice = self.exercise[n][0]
			self.setCurrent(self.exercise[n][1])
		# doing some exercise - do a little more exercise
		elif self.exerciseLevel == 1:
			n = random.randint(2,3)
			advice = self.exercise[n][0]
			self.setCurrent(self.exercise[n][1])
		# doing regular exercise - continue to exercise regularly
		else:
			advice = self.exercise[4][0]
			self.setCurrent(self.exercise[4][1])
		return advice
	
	def getCaffeineAdvice(self):
		# chose suggestion at random to reduce their caffeine intake
		n = random.randint(0,1)
		if n == 0:
			advice = (self.caffeine[0][0] + str(self.numberCoffees - 1) + ' coffees')
		else:
			advice = (self.caffeine[1][0] + str(self.sleepStart - 4) + ':00')
		self.setCurrent(self.caffeine[n][1])
		return advice
			
	def getMealAdvice(self):
		# chose suggestion at random to improve their evening meals
		n = random.randint(0,4)
		advice = self.meal[n][0]
		self.setCurrent(self.meal[n][1])
		return advice

	def getNicotineAdvice(self):
		# make suggestion that they avoid smoking within a hour of going to bed
		if self.isSmoker == False:
			advice = 'empty advice'
		else:
			advice = self.nicotine[0][0]
			self.setCurrent(self.nicotine[0][1])
		return advice

	def getAlcoholAdvice(self):
		# chose suggestion at random to reduce alcohol consumption immediately before bed
		n = random.randint(0,1)
		if n == 0:
			advice = self.alcohol[0][0]
		else:
			advice = (self.alcohol[1][0] + str(self.sleepStart - 1) + ':00')
		self.setCurrent(self.alcohol[n][1])
		return advice

	def getRelaxationAdvice(self):
		# chose suggestion at random to try a form of relaxation
		n = random.randint(0,3)
		advice = self.relaxation[n][0]
		self.setCurrent(self.relaxation[n][1])
		return advice

	def getLightAdvice(self):
		# chose suggestion at random to make the room darker
		n = random.randint(0,1)
		advice = self.light[n][0]
		self.setCurrent(self.light[n][1])
		return advice

	def getNoiseAdvice(self):
		# chose suggestion at random to make the room darker
		if self.isHot == False:
			n = random.randint(0,1)
			advice = self.noise[n][0]
			self.setCurrent(self.noise[n][1])
		else:
			advice = self.noise[1][0]
			self.setCurrent(self.noise[1][1])
		return advice

	def getTemperatureAdvice(self):
		# chose suggestion at random to make the room temperature between 18 and 24
		if self.isHot == False:
			n = random.randint(0,2)
			if n == 1:
				advice = (self.temperature[1][0] + str(self.coldTime) + ':00')
			else:
				advice = self.temperature[n][0]
			self.setCurrent(self.temperature[n][1])
		else:
			n = random.randint(3,4)
			advice = self.temperature[n][0]
			self.setCurrent(self.temperature[n][1])
		return advice

	def getHumidityAdvice(self):
		# make suggestion that they use a de-humidifier to reduce humidity
		advice = self.humidity[0][0]
		self.setCurrent(self.humidity[0][1])
		return advice

	def getDeviceAdvice(self):
		# make suggestion to reduce device use before bed
		n = self.deviceEffect
		advice = (self.device[n][0] + str(self.sleepStart - 2) + ':00')
		self.setCurrent(self.device[n][1])
		return advice
		
			
	def setSleepDuration(self, n):
		self.sleepDuration = n
			
	def setSleepStart(self, t):
		self.sleepStart = t
		
	def setExerciseLevel(self, n):
		self.exerciseLevel = n
		
	def setNumberCoffees(self, n):
		self.numberCoffees = n
		
	def setIsHot(self, b):
		self.isHot = b
		
	def setColdTime(self, t):
		self.coldTime = t
		
	def setDeviceEffect(self, n):
		self.deviceEffect = n
		
	def setSmoker(self, b):
		self.isSmoker = b
	
	
	def setCount(self, n):
		self.count = n
		
	def setPrevious(self, n):
		self.previous = n
		
	def setCurrent(self, n):
		self.current = n
		
		
	def removeSuggestion(self, group, advice):
		# removes advice and all similar (same subgroup) permanently from the lists
		if group is 'duration':
			subgroup = [x[1] for x in self.duration if x[0] == advice][0]
			s = []
			for i in range(0, len(self.duration)):
				if self.duration[i][1] == subgroup:
					s.append(self.duration[i])
			for a in s:
				self.duration.remove(a)
		elif group is 'exercise':
			subgroup = [x[1] for x in self.exercise if x[0] == advice][0]
			s = []
			for i in range(0, len(self.exercise)):
				if self.exercise[i][1] == subgroup:
					s.append(self.exercise[i])
			for a in s:
				self.exercise.remove(a)
		elif group is 'caffeine':
			subgroup = [x[1] for x in self.caffeine if x[0] == advice][0]
			s = []
			for i in range(0, len(self.caffeine)):
				if self.caffiene[i][1] == subgroup:
					s.append(self.caffeine[i])
			for a in s:
				self.caffeine.remove(a)
		elif group is 'meal':
			subgroup = [x[1] for x in self.meal if x[0] == advice][0]
			s = []
			for i in range(0, len(self.meal)):
				if self.meal[i][1] == subgroup:
					s.append(self.meal[i])
			for a in s:
				self.meal.remove(a)
		elif group is 'nicotine':
			subgroup = [x[1] for x in self.nicotine if x[0] == advice][0]
			s = []
			for i in range(0, len(self.nicotine)):
				if self.nicotine[i][1] == subgroup:
					s.append(self.nicotine[i])
			for a in s:
				self.nicotine.remove(a)
		elif group is 'alcohol':
			subgroup = [x[1] for x in self.alcohol if x[0] == advice][0]
			s = []
			for i in range(0, len(self.alcohol)):
				if self.alcohol[i][1] == subgroup:
					s.append(self.alcohol[i])
			for a in s:
				self.alcohol.remove(a)
		elif group is 'relaxation':
			subgroup = [x[1] for x in self.relaxation if x[0] == advice][0]
			s = []
			for i in range(0, len(self.relaxation)):
				if self.relaxation[i][1] == subgroup:
					s.append(self.relaxation[i])
			for a in s:
				self.relaxation.remove(a)
		elif group is 'light':
			subgroup = [x[1] for x in self.light if x[0] == advice][0]
			s = []
			for i in range(0, len(self.light)):
				if self.light[i][1] == subgroup:
					s.append(self.light[i])
			for a in s:
				self.light.remove(a)
		elif group is 'noise':
			subgroup = [x[1] for x in self.noise if x[0] == advice][0]
			s = []
			for i in range(0, len(self.noise)):
				if self.noise[i][1] == subgroup:
					s.append(self.noise[i])
			for a in s:
				self.noise.remove(a)
		elif group is 'temperature':
			subgroup = [x[1] for x in self.temperature if x[0] == advice][0]
			s = []
			for i in range(0, len(self.temperature)):
				if self.temperature[i][1] == subgroup:
					s.append(self.temperature[i])
			for a in s:
				self.temperature.remove(a)
		elif group is 'humidity':
			subgroup = [x[1] for x in self.humidity if x[0] == advice][0]
			s = []
			for i in range(0, len(self.humidity)):
				if self.humidity[i][1] == subgroup:
					s.append(self.humidity[i])
			for a in s:
				self.humidity.remove(a)
		elif group is 'device':
			subgroup = [x[1] for x in self.devce if x[0] == advice][0]
			s = []
			for i in range(0, len(self.device)):
				if self.device[i][1] == subgroup:
					s.append(self.device[i])
			for a in s:
				self.device.remove(a)
		else:
			print 'group not found'