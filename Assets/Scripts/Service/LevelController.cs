using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace resume.Service
{
	public class LevelController : MonoBehaviour 
	{
		private const int START_LEVEL_INDEX = 0;
		[SerializeField]
		private GameObject[] levelPrefabs;
		private int levelIndex;

		private void OnEnable() 
		{
			levelIndex = START_LEVEL_INDEX;
		}
	
	
	}
}