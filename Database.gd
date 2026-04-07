extends Node

@export var enemies : Array[EnemyData] = []
@export var items : Array[ItemData] = []
@export var bosses : Array[BossData] = []

func get_enemy( _name : String ) -> EnemyData:
	return enemies.filter( func(e): return e.name == _name ).front()

func get_item( _name : String ) -> ItemData:
	return items.filter( func(i): return i.name == _name ).front()

func get_boss( _name : String ) -> BossData:
	return bosses.filter( func(b): return b.name == _name ).front()
