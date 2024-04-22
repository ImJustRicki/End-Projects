using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    public int world { get; private set; }
    public int stage { get; private set; }
    public int lives { get; private set; }
    public int coins { get; private set; }
    public int timer { get; private set; }

    private Text coinCountText;
    private Text timerText;
    private Text livesText;

    private void Awake()
    {
        if (Instance != null)
        {
            DestroyImmediate(gameObject);
        }
        else
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
    }

    private void OnDestroy()
    {
        if (Instance == this)
        {
            Instance = null;
        }
    }

    private void Start()
    {
        Application.targetFrameRate = 60;
        Canvas canvas = GetComponentInChildren<Canvas>();
        if (canvas != null)
        {
            coinCountText = canvas.transform.Find("coinCountText").GetComponent<Text>();
            if (coinCountText == null)
            {
                Debug.LogError("Coin count text object not found.");
            }

            timerText = canvas.transform.Find("timerText").GetComponent<Text>();
            if (timerText == null)
            {
                Debug.LogError("Timer text object not found.");
            }

            livesText = canvas.transform.Find("livesText").GetComponent<Text>();
            if (livesText == null)
            {
                Debug.LogError("Lives text object not found.");
            }

            
            if (coinCountText != null && timerText != null && livesText != null)
            {
                StartCoroutine(StartTimer());
            }
            else
            {
                Debug.LogError("One or more text objects not found.");
            }
        }
        else
        {
            Debug.LogError("Canvas not found.");
        }

        NewGame();
    }

    public void NewGame()
    {
        lives = 3;
        coins = 0;
        timer = 400; 
        UpdateCoinCountText();
        UpdateTimerText();
        UpdateLivesText();

        LoadLevel(1, 1);
        StartCoroutine(StartTimer());
    }

    public void GameOver()
    {

        NewGame();
    }

    public void LoadLevel(int world, int stage)
    {
        this.world = world;
        this.stage = stage;

        SceneManager.LoadScene($"{world}-{stage}");
    }

    public void NextLevel()
    {
        LoadLevel(world, stage + 1);
    }

    public void ResetLevel(float delay)
    {
        CancelInvoke(nameof(ResetLevel));
        Invoke(nameof(ResetLevel), delay);
    }

    public void ResetLevel()
    {
        lives--;

        if (lives > 0)
        {
            LoadLevel(world, stage);
        }
        else
        {
            GameOver();
        }
        UpdateLivesText(); 
    }


    public void AddCoin()
    {
        coins++;

        if (coins == 100)
        {
            coins = 0;
            AddLife();
        }
        UpdateCoinCountText();
    }

    public void AddLife()
    {
        lives++;
    }

    private void UpdateCoinCountText()
    {
        if (coinCountText != null)
        {
            coinCountText.text = "X " + coins.ToString("D2");
        }
    }

    private void UpdateTimerText()
    {
        if (timerText != null)
        {
            timerText.text = timer.ToString("D3");
        }
    }

    private void UpdateLivesText()
    {
        if (livesText != null)
        {
            livesText.text = "X " + lives.ToString("D2");
        }
    }

    private IEnumerator StartTimer()
    {
        while (timer > 0)
        {
            yield return new WaitForSeconds(1f);
            Debug.Log("Timer: " + timer); 
            timer--; 
            UpdateTimerText(); 
        }
        Debug.Log("OUT OF TIME"); 
        ResetLevel(); 
    }
}

