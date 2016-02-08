class test ($var, $vartwo) {
	notify { "I know the unencrypted var, $var.": }
	notify { "And the encrypted one, $vartwo.": }
}
