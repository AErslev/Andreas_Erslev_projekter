#include "Player.h"

Player::Player()
{
	playerName_ = details.getUserName();
}

void Player::changePin()
{
	bankAccount_.changePin();
}

void Player::changeSaldo(int saldo)
{
	bankAccount_.setSaldo(saldo);
}

void Player::carSale(int amount, int status)
{
	bankAccount_.carSale(amount, status);
}

string Player::getPlayerName()
{
	return playerName_;
}

const void Player::printOwner()
{
	cout << "Car is owned by: " << playerName_ << endl << endl;
}

void Player::accessBank()
{
	bankAccount_.printMenu(playerName_);
}

void Player::work(Time* clock)
{
	payCheck_ = playerJob_.work(clock);
	bankAccount_.payDay(payCheck_);
}

