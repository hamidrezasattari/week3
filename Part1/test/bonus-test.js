// [bonus] unit test for bonus.circom
const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;
const { buildPoseidon } = require('circomlibjs');



const assert = chai.assert;

describe("Bonus testing", function () {
    this.timeout(100000000);
    const current = process.cwd()

	it("", async () => {
		const circuit = await wasm_tester(
			current +"/contracts/circuits/bonus.circom"
		);
		await circuit.loadConstraints();
		let poseidon = await buildPoseidon();
		let F = poseidon.F;
		let res = poseidon([3457890, 1, 0]);

		const INPUT = {
			pubGuessA: 1,
			pubGuessB: 0,
			pubSolnHash: F.toObject(res),
			privSolnA: 1,
			privSolnB: 0,
			privSalt: 3457890
		};
		const witness = await circuit.calculateWitness(INPUT, true);
		assert(F.eq(F.e(witness[1]), F.e(res)));
	});
});