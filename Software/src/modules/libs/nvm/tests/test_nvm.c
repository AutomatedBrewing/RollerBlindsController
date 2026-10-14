#include <cmocka.h>
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>

#include "nvm.h"
#include "ramdisk.h"

#define RECORD_HEADER_SIZE 8U
#define RECORD_PAYLOAD_OFFSET RECORD_HEADER_SIZE
#define RECORD_CRC_OFFSET 16U
#define RECORD_COMMIT_OFFSET 24U
#define RECORD_SIZE_FOR_U32 32U

static const struct nvm_backend_config backend_config = {
    .base_address = 0U, .size = RAMDISK_SIZE, .erase_size = RAMDISK_SIZE, .program_size = 8U};

static const struct nvm_object objects[] = {{.id = NVM_ID_TRAVEL_TIME, .size = sizeof(uint32_t)}};

static const struct nvm_config nvm_config = {.backend_api = &ramdisk_backend,
                                             .backend_config = &backend_config,
                                             .objects = objects,
                                             .object_count = (uint8_t)(sizeof(objects) / sizeof(objects[0]))};

static int test_setup(void **state)
{
    (void)state;

    ramdisk_reset();

    /* nvm_init(NULL) resets the module's private state before rejecting input. */
    assert_int_equal(nvm_init(NULL), NVM_INVALID_ARGUMENT);

    return 0;
}

static enum nvm_result initialize_nvm(void)
{
    return nvm_init(&nvm_config);
}

static void test_GivenEmptyRamDisk_WhenNvmInit_ThenReturnsOk(void **state)
{
    (void)state;

    /* ARRANGE */
    /* Setup leaves the RAM disk erased. */

    /* ACT */
    enum nvm_result result = initialize_nvm();

    /* ASSERT */
    assert_int_equal(result, NVM_OK);
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
    assert_int_equal(nvm_read(NVM_ID_TRAVEL_TIME, &(uint32_t){0U}), NVM_NOT_FOUND);
}

static void test_GivenNullConfig_WhenNvmInit_ThenReturnsInvalidArgument(void **state)
{
    (void)state;

    /* ARRANGE */

    /* ACT */
    enum nvm_result result = nvm_init(NULL);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenMissingBackendConfig_WhenNvmInit_ThenReturnsInvalidArgument(void **state)
{
    (void)state;
    struct nvm_config config = nvm_config;

    /* ARRANGE */
    config.backend_config = NULL;

    /* ACT */
    enum nvm_result result = nvm_init(&config);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenBackendInitFailure_WhenNvmInit_ThenReturnsIoError(void **state)
{
    (void)state;

    /* ARRANGE */
    ramdisk_fail_init(true);

    /* ACT */
    enum nvm_result result = initialize_nvm();

    /* ASSERT */
    assert_int_equal(result, NVM_IO_ERROR);
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
}

static void test_GivenInvalidObjectId_WhenNvmInit_ThenReturnsInvalidArgument(void **state)
{
    (void)state;
    const struct nvm_object invalid_objects[] = {{.id = (enum nvm_id)NVM_ID_COUNT, .size = sizeof(uint32_t)}};
    struct nvm_config config = nvm_config;

    /* ARRANGE */
    config.objects = invalid_objects;

    /* ACT */
    enum nvm_result result = nvm_init(&config);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenZeroSizedObject_WhenNvmInit_ThenReturnsInvalidArgument(void **state)
{
    (void)state;
    const struct nvm_object invalid_objects[] = {{.id = NVM_ID_TRAVEL_TIME, .size = 0U}};
    struct nvm_config config = nvm_config;

    /* ARRANGE */
    config.objects = invalid_objects;

    /* ACT */
    enum nvm_result result = nvm_init(&config);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenObjectLargerThanMaximum_WhenNvmInit_ThenReturnsInvalidArgument(void **state)
{
    (void)state;
    const struct nvm_object invalid_objects[] = {{.id = NVM_ID_TRAVEL_TIME, .size = 65U}};
    struct nvm_config config = nvm_config;

    /* ARRANGE */
    config.objects = invalid_objects;

    /* ACT */
    enum nvm_result result = nvm_init(&config);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenReadFailure_WhenNvmInit_ThenReturnsIoError(void **state)
{
    (void)state;

    /* ARRANGE */
    ramdisk_fail_read_after(0U);

    /* ACT */
    enum nvm_result result = initialize_nvm();

    /* ASSERT */
    assert_int_equal(result, NVM_IO_ERROR);
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
}

static void test_GivenUnwrittenObject_WhenNvmRead_ThenReturnsNotFound(void **state)
{
    uint32_t value = 0U;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ACT */
    enum nvm_result result = nvm_read(NVM_ID_TRAVEL_TIME, &value);

    /* ASSERT */
    assert_int_equal(result, NVM_NOT_FOUND);
}

static void test_GivenInitializedNvm_WhenReadNullPointer_ThenReturnsInvalidArgument(void **state)
{
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ACT */
    enum nvm_result result = nvm_read(NVM_ID_TRAVEL_TIME, NULL);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenInitializedNvm_WhenReadInvalidId_ThenReturnsInvalidId(void **state)
{
    uint32_t value = 0U;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ACT */
    enum nvm_result result = nvm_read((enum nvm_id)NVM_ID_COUNT, &value);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ID);
}

static void test_GivenInitializedNvm_WhenWriteNullPointer_ThenReturnsInvalidArgument(void **state)
{
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ACT */
    enum nvm_result result = nvm_write(NVM_ID_TRAVEL_TIME, NULL);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenInitializedNvm_WhenWriteInvalidId_ThenReturnsInvalidId(void **state)
{
    const uint32_t value = UINT32_C(123456);
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ACT */
    enum nvm_result result = nvm_write((enum nvm_id)NVM_ID_COUNT, &value);

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ID);
}

static void test_GivenValidValue_WhenWriteAndRead_ThenReturnsSameValue(void **state)
{
    const uint32_t expected = UINT32_C(123456);
    uint32_t actual = 0U;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ACT */
    enum nvm_result write_result = nvm_write(NVM_ID_TRAVEL_TIME, &expected);
    enum nvm_result read_result = nvm_read(NVM_ID_TRAVEL_TIME, &actual);

    /* ASSERT */
    assert_int_equal(write_result, NVM_OK);
    assert_int_equal(read_result, NVM_OK);
    assert_int_equal(actual, expected);
    assert_true(nvm_is_valid(NVM_ID_TRAVEL_TIME));
}

static void test_GivenStoredValue_WhenNvmIsReinitialized_ThenRecoversValue(void **state)
{
    const uint32_t expected = UINT32_C(98765);
    uint32_t actual = 0U;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &expected), NVM_OK);

    /* ACT */
    assert_int_equal(initialize_nvm(), NVM_OK);
    enum nvm_result result = nvm_read(NVM_ID_TRAVEL_TIME, &actual);

    /* ASSERT */
    assert_int_equal(result, NVM_OK);
    assert_int_equal(actual, expected);
}

static void test_GivenMultipleUpdates_WhenNvmIsReinitialized_ThenRecoversLatestValue(void **state)
{
    const uint32_t first = UINT32_C(100);
    const uint32_t second = UINT32_C(200);
    const uint32_t latest = UINT32_C(300);
    uint32_t actual = 0U;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &first), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &second), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &latest), NVM_OK);

    /* ACT */
    assert_int_equal(initialize_nvm(), NVM_OK);
    enum nvm_result result = nvm_read(NVM_ID_TRAVEL_TIME, &actual);

    /* ASSERT */
    assert_int_equal(result, NVM_OK);
    assert_int_equal(actual, latest);
}

static void test_GivenPayloadCorruption_WhenNvmIsReinitialized_ThenRejectsRecord(void **state)
{
    const uint32_t expected = UINT32_C(0x12345678);
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &expected), NVM_OK);
    assert_true(ramdisk_corrupt_byte(RECORD_PAYLOAD_OFFSET, 0x00U));

    /* ACT */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ASSERT */
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
    assert_int_equal(nvm_read(NVM_ID_TRAVEL_TIME, &(uint32_t){0U}), NVM_NOT_FOUND);
}

static void test_GivenCommitMarkerCorruption_WhenNvmIsReinitialized_ThenRejectsRecord(void **state)
{
    const uint32_t expected = UINT32_C(0x12345678);
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &expected), NVM_OK);
    assert_true(ramdisk_corrupt_byte(RECORD_COMMIT_OFFSET, 0xFFU));

    /* ACT */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ASSERT */
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
}

static void test_GivenWriteFailureBeforeHeader_WhenNvmWrite_ThenReturnsIoError(void **state)
{
    const uint32_t value = UINT32_C(42);
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    ramdisk_fail_write_after(0U);

    /* ACT */
    enum nvm_result result = nvm_write(NVM_ID_TRAVEL_TIME, &value);

    /* ASSERT */
    assert_int_equal(result, NVM_IO_ERROR);
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
}

static void test_GivenInterruptedRecord_WhenNvmIsReinitialized_ThenDoesNotRecoverIt(void **state)
{
    const uint32_t value = UINT32_C(42);
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    /* Header write succeeds; payload write fails. */
    ramdisk_fail_write_after(1U);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &value), NVM_IO_ERROR);

    /* ACT */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* ASSERT */
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
}

static void test_GivenStoredValue_WhenFormatSucceeds_ThenClearsCacheAndStorage(void **state)
{
    const uint32_t value = UINT32_C(42);
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &value), NVM_OK);

    /* ACT */
    enum nvm_result result = nvm_format();

    /* ASSERT */
    assert_int_equal(result, NVM_OK);
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
    assert_int_equal(nvm_read(NVM_ID_TRAVEL_TIME, &(uint32_t){0U}), NVM_NOT_FOUND);
}

static void test_GivenEraseFailure_WhenFormat_ThenReturnsIoErrorAndKeepsCache(void **state)
{
    const uint32_t expected = UINT32_C(42);
    uint32_t actual = 0U;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);
    assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &expected), NVM_OK);
    ramdisk_fail_erase_after(0U);

    /* ACT */
    enum nvm_result result = nvm_format();

    /* ASSERT */
    assert_int_equal(result, NVM_IO_ERROR);
    assert_true(nvm_is_valid(NVM_ID_TRAVEL_TIME));
    assert_int_equal(nvm_read(NVM_ID_TRAVEL_TIME, &actual), NVM_OK);
    assert_int_equal(actual, expected);
}

static void test_GivenFullPage_WhenWritingAnotherValue_ThenCompactsAndKeepsLatestValue(void **state)
{
    uint32_t value;
    uint32_t actual = 0U;
    uint32_t index;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    /* Eight 32-byte records fill the 256-byte page. */
    for (index = 0U; index < (RAMDISK_SIZE / RECORD_SIZE_FOR_U32); ++index)
    {
        value = index + 1U;
        assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &value), NVM_OK);
    }

    /* ACT: this write must compact before appending. */
    value = UINT32_C(999);
    enum nvm_result result = nvm_write(NVM_ID_TRAVEL_TIME, &value);

    /* ASSERT */
    assert_int_equal(result, NVM_OK);
    assert_int_equal(nvm_read(NVM_ID_TRAVEL_TIME, &actual), NVM_OK);
    assert_int_equal(actual, value);

    /* Verify that the compacted representation is recoverable. */
    assert_int_equal(initialize_nvm(), NVM_OK);
    actual = 0U;
    assert_int_equal(nvm_read(NVM_ID_TRAVEL_TIME, &actual), NVM_OK);
    assert_int_equal(actual, value);
}

static void test_GivenUninitializedNvm_WhenFormat_ThenReturnsInvalidArgument(void **state)
{
    (void)state;

    /* ARRANGE */
    /* test_setup() leaves the module uninitialized. */

    /* ACT */
    enum nvm_result result = nvm_format();

    /* ASSERT */
    assert_int_equal(result, NVM_INVALID_ARGUMENT);
}

static void test_GivenRepeatedWrites_WhenReinitialized_ThenRecoversLastValue(void **state)
{
    uint32_t value;
    uint32_t actual = 0U;
    uint32_t index;
    (void)state;

    /* ARRANGE */
    assert_int_equal(initialize_nvm(), NVM_OK);

    for (index = 0U; index < 40U; ++index)
    {
        value = (index * UINT32_C(37)) ^ UINT32_C(0xA5A55A5A);
        assert_int_equal(nvm_write(NVM_ID_TRAVEL_TIME, &value), NVM_OK);
    }

    /* ACT */
    assert_int_equal(initialize_nvm(), NVM_OK);
    value = (39U * UINT32_C(37)) ^ UINT32_C(0xA5A55A5A);
    enum nvm_result result = nvm_read(NVM_ID_TRAVEL_TIME, &actual);

    /* ASSERT */
    assert_int_equal(result, NVM_OK);
    assert_int_equal(actual, value);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test_setup(test_GivenEmptyRamDisk_WhenNvmInit_ThenReturnsOk, test_setup),
        cmocka_unit_test_setup(test_GivenNullConfig_WhenNvmInit_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenMissingBackendConfig_WhenNvmInit_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenBackendInitFailure_WhenNvmInit_ThenReturnsIoError, test_setup),
        cmocka_unit_test_setup(test_GivenInvalidObjectId_WhenNvmInit_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenZeroSizedObject_WhenNvmInit_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenObjectLargerThanMaximum_WhenNvmInit_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenReadFailure_WhenNvmInit_ThenReturnsIoError, test_setup),
        cmocka_unit_test_setup(test_GivenUnwrittenObject_WhenNvmRead_ThenReturnsNotFound, test_setup),
        cmocka_unit_test_setup(test_GivenInitializedNvm_WhenReadNullPointer_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenInitializedNvm_WhenReadInvalidId_ThenReturnsInvalidId, test_setup),
        cmocka_unit_test_setup(test_GivenInitializedNvm_WhenWriteNullPointer_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenInitializedNvm_WhenWriteInvalidId_ThenReturnsInvalidId, test_setup),
        cmocka_unit_test_setup(test_GivenValidValue_WhenWriteAndRead_ThenReturnsSameValue, test_setup),
        cmocka_unit_test_setup(test_GivenStoredValue_WhenNvmIsReinitialized_ThenRecoversValue, test_setup),
        cmocka_unit_test_setup(test_GivenMultipleUpdates_WhenNvmIsReinitialized_ThenRecoversLatestValue, test_setup),
        cmocka_unit_test_setup(test_GivenPayloadCorruption_WhenNvmIsReinitialized_ThenRejectsRecord, test_setup),
        cmocka_unit_test_setup(test_GivenCommitMarkerCorruption_WhenNvmIsReinitialized_ThenRejectsRecord, test_setup),
        cmocka_unit_test_setup(test_GivenWriteFailureBeforeHeader_WhenNvmWrite_ThenReturnsIoError, test_setup),
        cmocka_unit_test_setup(test_GivenInterruptedRecord_WhenNvmIsReinitialized_ThenDoesNotRecoverIt, test_setup),
        cmocka_unit_test_setup(test_GivenStoredValue_WhenFormatSucceeds_ThenClearsCacheAndStorage, test_setup),
        cmocka_unit_test_setup(test_GivenEraseFailure_WhenFormat_ThenReturnsIoErrorAndKeepsCache, test_setup),
        cmocka_unit_test_setup(test_GivenFullPage_WhenWritingAnotherValue_ThenCompactsAndKeepsLatestValue, test_setup),
        cmocka_unit_test_setup(test_GivenUninitializedNvm_WhenFormat_ThenReturnsInvalidArgument, test_setup),
        cmocka_unit_test_setup(test_GivenRepeatedWrites_WhenReinitialized_ThenRecoversLastValue, test_setup)};

    return cmocka_run_group_tests(tests, NULL, NULL);
}
