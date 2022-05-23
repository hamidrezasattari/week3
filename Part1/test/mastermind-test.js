//[assignment] write your own unit test to show that your Mastermind variation circuit is working as expected
const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;
const { buildPoseidon } = require('circomlibjs');



const assert = chai.assert;

describe("Deluxe Mastermind testing", function () {
    this.timeout(100000000);
    const current = process.cwd()

	it("", async () => {
		const circuit = await wasm_tester(
			current +"/contracts/circuits/MastermindVariation.circom"
		);
		await circuit.loadConstraints();
		let poseidon = await buildPoseidon();
		let F = poseidon.F;
		let res = poseidon([5745720, 1, 4,3, 2, 5]);

		const INPUT = {
			pubGuessA: 1,
			pubGuessB: 4,
			pubGuessC: 3,
			pubGuessD: 2,
			pubGuessE: 5,
			pubNumHit: 5,
            pubNumBlow: 0,
			pubSolnHash: F.toObject(res),
			privSolnA: 1,
			privSolnB: 4,
			privSolnC: 3,
			privSolnD: 2,
			privSolnE:5,
			privSalt: 5745720,
		};
		const witness = await circuit.calculateWitness(INPUT, true);
		assert(F.eq(F.e(witness[1]), F.e(res)));
	});
});