extends Node

var machine: Machine = null

##
# @brief Sets the global parameters for the project.
# @param m_machine The machine to be used in the core of the program
##
func set_machine(m_machine: Machine) -> void:
	self.machine = m_machine
