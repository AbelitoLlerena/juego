class_name AttackStats
extends RefCounted

## Precisión
var precision:float = 0

## Crítico
var critical_chance:float = 0
var critical_multiplier:float = 1

## Penetración
var armor_penetration:float = 0

## Robo
var life_steal:float = 0
var energy_steal:float = 0

## Daños
var physical_damage:float = 0
var magical_damage:float = 0
var true_damage:float = 0

## Probabilidades de efectos
var effect_chances := {}
