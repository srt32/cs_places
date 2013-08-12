require_relative 'PlaceRequest'

req = PlaceRequest.new(reqType = "place",
						key = "AIzaSyC2aZ5uDR1lR0ucYpo4PTWV_4pXbZPmow4",
						location = '42.448734650355775,-76.47395993447884',
						radius = "1000",
						sensor = "false")

req.callIt