#!/usr/bin/python3
import os
import requests
import json
from brownie import Qolaba, network
from metadata import sample_metadata
from scripts.helpful_scripts import get_breed
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

breed_to_image_uri = {
    "PUG": "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8?filename=pug.png",
    "SHIBA_INU": "ipfs://QmYx6GsYAKnNzZ9A6NvEKV9nf1VaDzJrqDR23Y8YSkebLU?filename=shiba-inu.png",
    "ST_BERNARD": "ipfs://QmUPjADFGEKmfohdTaNcWhp7VGk26h5jXDA7v3VtTnTLcW?filename=st-bernard.png",
}


def main():
    print("Working on " + network.show_active())
    nft_marketplace = Qolaba[len(Qolaba) - 1]
    number_of_advanced_collectibles = nft_marketplace.fetchMarketItems()
    print(number_of_advanced_collectibles[0])
    print(type(number_of_advanced_collectibles))
    print(
        "The number of tokens you've deployed is: "
        + str(number_of_advanced_collectibles)
    )
    write_metadata(1)


def write_metadata(token_ids):
    for token_id in range(token_ids):
        collectible_metadata = sample_metadata.metadata_template
        # breed = get_breed(nft_contract.tokenIdToBreed(token_id))
        metadata_file_name = (
            "./metadata/{}/".format(network.show_active())
            + str(token_id)
            + "-"
            + collectible_metadata['name'].lower().replace(" ", "")
            + ".json"
        )
        if Path(metadata_file_name).exists():
            print(
                "{} already found, delete it to overwrite!".format(
                    metadata_file_name)
            )
        else:
            print("Creating Metadata file: " + metadata_file_name)
            # collectible_metadata["name"] = get_breed(
            #     nft_contract.tokenIdToBreed(token_id)
            # )
            # collectible_metadata["description"] = "An adorable {} pup!".format(
            #     collectible_metadata["name"]
            # )
            image_to_upload = None
            if os.getenv("UPLOAD_IPFS") == "true":
                image_path = "./img/{}.png".format('ufo1')
                image_to_upload = upload_to_ipfs(image_path)
            # image_to_upload = (
            #     breed_to_image_uri[breed] if not image_to_upload else image_to_upload
            # )
            collectible_metadata["image"] = image_to_upload
            with open(metadata_file_name, "w") as file:
                json.dump(collectible_metadata, file)
            if os.getenv("UPLOAD_IPFS") == "true":
                upload_to_ipfs(metadata_file_name)

# curl -X POST -F file=@metadata/rinkeby/0-SHIBA_INU.json http://localhost:5001/api/v0/add


def upload_to_ipfs(filepath):
    with Path(filepath).open("rb") as fp:
        image_binary = fp.read()
        ipfs_url = (
            os.getenv("IPFS_URL")
            if os.getenv("IPFS_URL")
            else "http://localhost:5001"
        )
        response = requests.post(ipfs_url + "/api/v0/add",
                                 files={"file": image_binary})
        ipfs_hash = response.json()["Hash"]
        filename = filepath.split("/")[-1:][0]
        image_uri = "ipfs://{}?filename={}".format(
            ipfs_hash, filename)
        print(image_uri)
    return image_uri
