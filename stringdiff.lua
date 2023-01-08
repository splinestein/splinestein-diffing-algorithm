--!strict

--[[
String similarity metric system / splinestein diffing algorithm.
Free to use!
]]

local StringDiff = {}


function StringDiff.longest_word(a: string, b: string) : (string, string)
	-- Commutative; makes a the longest string.
	if #a < #b then
		a, b = b, a
	end
	return a, b
end


function StringDiff.longest_number(a: number, b: number) : (number, number)
	-- Commutative; makes a the longest number.
	if a < b then
		a, b = b, a
	end
	return a, b
end


function StringDiff.longest_common_match(a: string, b: string) : (string, number)
	-- Create an empty table to store the matches & count all matches.
	local matches: {[number]: string} = {}
	local all_match_count = 0

	-- Iterate over the characters in b for each character in a.
	for i = 1, #a do
		for j = 1, #b do
			-- Create an empty table to store the current match and iterate over the characters, starting at index i.
			local current_match: {[number]: string} = {}
			for k = i, #a do
				-- Check if the character at index k in a is the same as the character at index j in b.
				if string.sub(a, k, k) == string.sub(b, j, j) then
					-- If the characters are the same, add the character to the current match table.
					table.insert(current_match, string.sub(a, k, k))
					-- Increment j to compare the next character in b.
					j += 1
				else
					-- If the characters are different, break the inner loop.
					break
				end
			end
			-- Skip empty matches, only store those we found.
			if #table.concat(current_match) > 0 then
				all_match_count += 1
			end
			-- Update the longest match if the current one is longer.
			if #current_match > #matches then
				matches = current_match
			end
		end
	end
	-- Return both the longest match and the count.
	return table.concat(matches), all_match_count
end


function StringDiff.perfect_common_match_calc(sentence: string) : number
	--[[ 
	In an ideal scenario, how many common matches would be made?
	If both strings are "aaabb" it's (equation): 
	(how many a's * how many a's) + unique letter (how many b's * how many b's) + ... = 13
	]]

	local counts: {[string]: number} = {}

	for i = 1, #sentence do
		local letter: string = string.sub(sentence, i, i)

		if counts[letter] then
			counts[letter] = counts[letter] + 1
		else
			counts[letter] = 1
		end
	end

	local total_matches = 0

	for _, count in pairs(counts) do
		total_matches += count * count
	end

	return total_matches
end


function StringDiff.compare(a: string, b: string) : (number, string)
	-- Core functionality:
	local a, b = StringDiff.longest_word(a, b)
	
	-- Just no point in comparing such small strings. Lift restriction if you feel like it.
	if #a < 1 then
		local errmsg = "Strings are too short to compare."
		warn(errmsg)
		return 0, "Strings are too short to compare."
	end
	
	local perfect_match_count = StringDiff.perfect_common_match_calc(a)

	local longest_match, all_match_count = StringDiff.longest_common_match(a, b)
	
	-- Core ratio logic calculation:
	local matches_length_compared = (#longest_match / #a) * 100 -- How big of a portion does the largest match take out of the sentence?
	local match_count_similarity = (all_match_count / perfect_match_count) * 100 -- How many matches could've been made in an ideal perfect scenario?
	local string_length_similarity = (#b / #a) * 100 -- How long both a and b are compared to each other?
	
	-- Finalization:
	local average_count_match_ratio = (matches_length_compared + match_count_similarity) / 2 -- Average out most important percentages, match length portion and count similarity for best result.
	
	-- We want to calculate how much we should change the ratio.
	local a_calc, b_calc = StringDiff.longest_number(average_count_match_ratio, string_length_similarity)
	
	local ratio = average_count_match_ratio * (((b_calc / a_calc) * 100) / 100)
	
	--[[ In a scenario where A and B are "Hey" and "How", you might think their general appearance, 
		is similar in that they are both three letters long and contain only lowercase letters. 
		However, this type of superficial similarity is not necessarily indicative of deeper similarity in meaning or usage. 
		Hence why I skip extra string_length_similarity checks that I could possibily utilize in the ratio. ]]
	
	return ratio, longest_match
end


return StringDiff
