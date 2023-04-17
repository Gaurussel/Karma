KARMA.config = {
    Degreese = {
        -- Отнимать карму при убийстве?
        mDeath = true,
        mDeathAmount = -10,
        -- Отнимать карму при дамаге?
        mDamage = true,
        mDamageAmount = -5,
        -- Отнимать карму при взломе (lockpeek)?
        mLockpeek = true,
        mLockpeekAmount = -3,
        -- Отнимать карму при ограблении?
        mRobbery = true,
        mRobberyAmount = -3,
        -- Отнимать карму при наведении оружия на игрока?
        mWepGuid = true,
        mWepGuidAmount = -3,
        -- Отнимать карму при заказе на убийство?
        mHitman = true,
        mHitmanAmount = -2,
    },
    Increase = {
        -- Прибавлять карму при первой помощи?
        iFA = true,
        iFAAmount = 10,
        -- Прибавлять карму при аресте виновных людей?
        iArrest = true,
        iArrestAmount = 10,
        -- Прибавлять карму при игре за мирные профессии?
        iPeaceful = true,
        iPeacefulAmount = 15,
    },
    -- Цветовая схема
    Colors = {
        text = Color(240, 240, 240),
        gray = Color(47, 53, 66),
        red = Color(231, 76, 60),
    },
    -- Стандартное значение кармы при создании персонажа
    default = 0,
    -- Мирные профессии
    PeacefulJobs = {},
    -- Раз в сколько времени будет даваться карма за мирные профессии
    PeacefulTime = 300,
    -- Нужно ли делать нотификации
    mNotification = true,
    -- Максимальное и минимальное значение кармы
    max = 100,
    min = -100,
    -- debug
    bDebug = true,
}

timer.Simple(0, function()
    KARMA.config.PeacefulJobs[TEAM_CITIZEN] = true
end)