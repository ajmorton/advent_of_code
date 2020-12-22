import read_as
import re
from copy import deepcopy
from collections import defaultdict

def recursive_combat(player_cards, crab_cards, history):

    while len(player_cards) > 0 and len(crab_cards) > 0:
        if (tuple(player_cards), tuple(crab_cards)) in history:
            return True, player_cards # player wins
        else:
            history[(tuple(player_cards), tuple(crab_cards))] = 1

        # draw
        player, player_cards = player_cards[0], player_cards[1:]
        crab, crab_cards = crab_cards[0], crab_cards[1:]

        if player <= len(player_cards) and crab <= len(crab_cards):
            winner, _ = recursive_combat(player_cards[:player], crab_cards[:crab], {})
            if winner:
                player_cards.extend([player, crab])
            else:
                crab_cards.extend([crab, player])
        else:
            if player > crab:
                player_cards.extend([player, crab])
            else:
                crab_cards.extend([crab, player])

    if len(player_cards) > 0:
        return True, player_cards
    else:
        return False, crab_cards

def combat(player_cards, crab_cards):
    if len(crab_cards) == 0:
        return player_cards
    elif len(player_cards) == 0:
        return crab_cards
    
    player, player_cards = player_cards[0], player_cards[1:]
    crab, crab_cards = crab_cards[0], crab_cards[1:]

    if player > crab:
        player_cards.extend([player, crab])
    else:
        crab_cards.extend([crab, player])

    return combat(player_cards, crab_cards)


def run() -> (int, int):
    groups = read_as.groups("input/22.txt")
    player_cards = [int(n) for n in groups[0][1:]]
    crab_cards = [int(n) for n in groups[1][1:]]

    prev_hands = {}

    winner_hand = combat(player_cards, crab_cards)
    _, hand_p2 = recursive_combat(player_cards, crab_cards, {})

    score = 0
    mult = 1
    for card in winner_hand[::-1]:
        score += mult * card
        mult += 1

    score_p2 = 0
    mult = 1
    for card in hand_p2[::-1]:
        score_p2 += mult * card
        mult += 1

    return (score, score_p2)

if __name__ == "__main__":
    print(run())